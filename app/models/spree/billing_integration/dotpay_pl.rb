class Spree::BillingIntegration::DotpayPl < Spree::BillingIntegration
  preference :dotpay_account_id, :string
  preference :dotpay_pin_code, :string
  preference :success_url, :string
  preference :currency_code, :string, default: "PLN"
  preference :dotpay_url, :string, default: 'https://ssl.dotpay.pl/t2/'
  preference :dotpay_whitelisted_ip, :string, default: '195.150.9.37'
  preference :dotpay_website_language, :string, default: 'pl'

  def payment_profiles_supported?
    false
  end

  def redirect_url(order)
    dotpay_params = {
      id: self.preferred_dotpay_account_id,
      type: '0', 
      amount: order.total.to_f,
      currency: options[:currency_code] || self.preferred_currency_code,
      description: "Payment for order: #{order.number}.",
      lang: self.preferred_dotpay_website_language.downcase,
      url: "#{self.preferred_success_url}?order_number=#{order.number}",
      charset: "utf-8",
      control: order.number,
      firstname: order.try(:billing_address).try(:firstname).to_s,
      lastname: order.try(:billing_address).try(:lastname).to_s,
      email: order.email
    }

    dotpay_params.merge!({ chk: generate_signature(dotpay_params) })

    "#{self.preferred_dotpay_url}?#{dotpay_params.to_query}"
  end

  def generate_signature(dotpay_params)
    signature_string = DOTPAY_PARAMS.each_with_object([]) do |dotpay_field, dotpay_params_array|
      dotpay_params_array << dotpay_params[dotpay_field]
    end.unshift(self.preferred_dotpay_pin_code).join

    Digest::SHA256.hexdigest(signature_string)
  end

  DOTPAY_PARAMS = [
    :api_version,
    :charset,
    :lang,
    :id,
    :amount,
    :currency,
    :description,
    :control,
    :channel,
    :credit_card_brand,
    :ch_lock,
    :channel_groups,
    :onlinetransfer,
    :url,
    :type,
    :buttontext,
    :urlc,
    :firstname,
    :lastname,
    :email,
    :street,
    :street_n1,
    :street_n2,
    :state,
    :addr3,
    :city,
    :postcode,
    :phone,
    :country,
    :code,
    :p_info,
    :p_email,
    :n_email,
    :expiration_date,
    :recipient_account_number,
    :recipient_company,
    :recipient_first_name,
    :recipient_last_name,
    :recipient_address_street,
    :recipient_address_building,
    :recipient_address_apartment,
    :recipient_address_postcode,
    :recipient_address_city,
    :warranty,
    :bylaw,
    :personal_data,
    :credit_card_number,
    :credit_card_expiration_date_year,
    :credit_card_expiration_date_month,
    :credit_card_security_code,
    :credit_card_store,
    :credit_card_store_security_code,
    :credit_card_customer_id,
    :credit_card_id,
    :blik_code,
    :credit_card_registration,
    :recurring_frequency,
    :recurring_interval,
    :recurring_start,
    :recurring_count
  ].freeze
end
