Spree::Order.class_eval do
  has_many :dotpay_callbacks

  def payable_via_dotpay?
    Spree::PaymentMethod.dotpay_payment_method.present?
  end
end
