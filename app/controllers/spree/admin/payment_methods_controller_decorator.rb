Spree::Admin::PaymentMethodsController.class_eval do
  before_action :validate_language_for_dotpay_payment_method, only: :update

  private
    DOTPAY_WEBSITE_LANGUAGES = %w(pl en de it fr es cz ru gb).freeze

    def validate_language_for_dotpay_payment_method
      if params[:payment_method][:type] == "Spree::BillingIntegration::DotpayPl" && DOTPAY_WEBSITE_LANGUAGES.exclude?(params[:billing_integration_dotpay_pl][:preferred_dotpay_website_language].downcase)
        flash[:error] = Spree.t(:invalid_dotpay_language)
        redirect_to edit_admin_payment_method_path
      end
    end
end
