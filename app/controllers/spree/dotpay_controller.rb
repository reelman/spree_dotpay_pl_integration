module Spree
  class DotpayController < ApplicationController
    skip_before_filter :verify_authenticity_token, :only => [:comeback, :notification]

    def comeback
      @order = Spree::Order.find_by(number: params[:order_number])
      if @order.state == "complete" && params[:status] == 'OK'
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to spree.order_path(@order)
      else
        redirect_to spree.order_path(@order)
      end
    end

    def notification
      notification_params = params.except('controller', 'action').symbolize_keys
      if @order = Spree::Order.find_by(number: notification_params[:control])
        @dotpay_callback = Spree::DotpayCallback.create(notification_params: notification_params, status: notification_params[:operation_status], operation_id: notification_params[:operation_number], order_id: @order.id)

        if @dotpay_callback.valid_callback?(request.remote_ip)
          @payment = @order.payments.last
          handle_notification unless @payment.completed? || @payment.failed? 
          render text: 'OK'
        else
          render text: 'NOT VALID'
        end
      else
        Rails.logger.info("Order not found during notification action in Dotpay controller. Notification params: #{notification_params}")
        render text: 'ORDER NOT FOUND'
      end
    end

    private

      def handle_notification
        if @dotpay_callback.notification_params[:operation_type] == "payment"
          case @dotpay_callback.status
          when "new" then payment_processing
          when "processing" then payment_processing
          when "completed" then payment_success
          when "rejected" then payment_cancel
          when "processing_realization_waiting" then payment_processing
          when "processing_realization" then payment_processing
          end
        end
      end

      def payment_cancel
        @payment.failure!
        @order.cancel
      end

      def payment_processing
        @payment.started_processing
        @order.finalize!
      end

      def payment_success
        @payment.started_processing
        if @order.total.to_f == @dotpay_callback.notification_params[:operation_amount].to_f
          @payment.complete!
        end

        @order.finalize!
        @order.reload

        @order.next
        @order.next
        @order.save
      end
  end
end
