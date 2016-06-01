module Spree
  class DotpayCallback < ActiveRecord::Base
    belongs_to :order, class_name: 'Spree::Order', foreign_key: 'order_id'
    serialize :notification_params, Hash

    def params=(params_hash)
      self[:notification_params] = params_hash.try(:symbolize_keys!)
    end

    def valid_callback?(remote_ip)
      valid_signature? && remote_ip == dotpay_whitelisted_ip
    end

    def valid_signature?
      notification_params[:signature] == generate_notification_signature
    end
    
    private

      DOTPAY_CALLBACK_FIELDS = [
        :id,
        :operation_number,
        :operation_type,
        :operation_status,
        :operation_amount,
        :operation_currency,
        :operation_withdrawal_amount,
        :operation_commission_amount,
        :operation_original_amount,
        :operation_original_currency,
        :operation_datetime,
        :operation_related_number,
        :control,
        :description,
        :email,
        :p_info,
        :p_email,
        :channel,
        :channel_country,
        :geoip_country
      ].freeze

      def generate_notification_signature
        signature_string = DOTPAY_CALLBACK_FIELDS.each_with_object([]) do |callback_field, callback_fields_array|
          callback_fields_array << notification_params[callback_field]
        end.unshift(pin_code).join

        Digest::SHA256.hexdigest(signature_string) 
      end

      def pin_code
        payment_method = Spree::PaymentMethod.dotpay_payment_method
        payment_method.present? ? payment_method.preferences[:dotpay_pin_code] : nil
      end

      def dotpay_whitelisted_ip
        payment_method = Spree::PaymentMethod.dotpay_payment_method
        payment_method.present? ? payment_method.preferences[:dotpay_whitelisted_ip] : nil
      end
  end
end
