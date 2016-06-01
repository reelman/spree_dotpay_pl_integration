class Spree::BillingIntegration::DotpayPl < Spree::BillingIntegration
  preference :dotpay_account_id, :string
  preference :dotpay_pin_code, :string
  preference :success_url, :string
  preference :currency_code, :string, default: "PLN"
  preference :dotpay_url, :string, default: 'https://ssl.dotpay.pl/t2/'
  preference :dotpay_whitelisted_ip, :string, default: '195.150.9.37'

  def payment_profiles_supported?
    false
  end
end
