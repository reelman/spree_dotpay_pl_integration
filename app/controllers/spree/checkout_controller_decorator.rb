Spree::CheckoutController.class_eval do

  before_filter :pay_with_dotpay, only: :update

  private

    def pay_with_dotpay
      return unless params[:state] == "payment"

      @payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if @payment_method && @payment_method.kind_of?(Spree::BillingIntegration::DotpayPl)
        dotpay_params = {
          id: @payment_method.preferences[:dotpay_account_id],
          type: '0', 
          amount: @order.total.to_f,
          currency: @payment_method.preferences[:currency_code],
          description: "Payment for order: #{@order.number}.",
          url: "#{@payment_method.preferences[:success_url]}?order_number=#{@order.number}",
          charset: "utf-8",
          control: @order.number,
          firstname: @order.try(:billing_address).try(:firstname).to_s,
          lastname: @order.try(:billing_address).try(:lastname).to_s,
          email: @order.email
        }

        signature = Spree::PaymentMethod.generate_dotpay_signature(dotpay_params)
        dotpay_params.merge!({ chk: signature })

        dotpay_payment_path = "#{@payment_method.preferences[:dotpay_url]}?#{dotpay_params.to_query}"

        @order.payments.with_state('checkout').where(payment_method_id: @payment_method.id).first_or_create(amount: @order.total)

        redirect_to dotpay_payment_path and return false
      end
    end
end
