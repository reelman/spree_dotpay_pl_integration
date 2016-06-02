Spree::PaymentMethod.class_eval do
  def self.dotpay_payment_method
    all.detect{ |payment_method| payment_method.name.downcase =~ /dotpay/ }
  end
end
