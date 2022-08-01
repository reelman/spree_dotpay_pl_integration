Spree::Core::Engine.routes.draw do
  match 'payments/dotpay/urlc-notification', to: 'dotpay#notification', via: [:get, :post]
  match 'payments/dotpay/comeback',          to: 'dotpay#comeback'    , via: [:get, :post]
end
