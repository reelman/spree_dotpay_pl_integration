Spree::CheckoutController.class_eval do

  before_filter :pay_with_dotpay, only: :update

  private

    def pay_with_dotpay
      return unless params[:state] == "payment"

      @payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      
      if @payment_method && @payment_method.kind_of?(Spree::BillingIntegration::DotpayPl)
        @order.payments.with_state('checkout').where(payment_method_id: @payment_method.id).first_or_create(amount: @order.total)
        redirect_to @payment_method.redirect_url(@order) and return false
      end
    end
end
