Spree::Core::Engine.routes.draw do
  post 'payments/dotpay/urlc-notification', to: 'dotpay#notification'
  post 'payments/dotpay/comeback', to: 'dotpay#comeback'
end
