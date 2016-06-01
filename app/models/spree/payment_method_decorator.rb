Spree::PaymentMethod.class_eval do
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

  def self.dotpay_payment_method
    all.detect{ |payment_method| payment_method.name.downcase =~ /dotpay/ }
  end

  def self.generate_dotpay_signature(params_hash)
    params_hash.symbolize_keys!
    
    signature_string = DOTPAY_PARAMS.each_with_object([]) do |dotpay_field, dotpay_params_array|
      dotpay_params_array << params_hash[dotpay_field]
    end.unshift(pin_code).join

    Digest::SHA256.hexdigest(signature_string)
  end

  #private

    def self.pin_code
      method = self.dotpay_payment_method
      method.present? ? method.preferences[:dotpay_pin_code] : nil
    end

    private_class_method :pin_code
end
