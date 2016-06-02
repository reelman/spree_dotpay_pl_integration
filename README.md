SpreeDotpayPlIntegration
========================

Spree integration with Dotpay payments.

Installation
------------

Add to your Spree application Gemfile:
```shell
gem 'spree_dotpay_pl_integration', git: 'git@github.com:SoftwareMansion/spree_dotpay_pl_integration.git', branch: 'master'
```

Run bundler to install dependencies:
```shell
bundle install
```

Run generator to install migrations and initializer:
```shell
rails generate spree_dotpay_pl_integration:install
```

Configuration
-------------

**Configuring Dotpay account:**

1. Go to **USTAWIENIA** and then to **POWIADOMIENIA**
2. Click on **EDIT** to edit your store configuration
3. Set up Urlc as: your_store_domain/payments/dotpay/urlc-notification
4. Set up 'Blokuj zewnętrzne urlc', 'HTTPS verify' and 'SSL certificate verify' to true
5. Click on **ZAPISZ**
6. Go to **USTAWIENIA** again and then to **KONFIGURACJA SKLEPU**
7. Set up **WERSJA API** to 'dev' (this gem supports only new Dotpay API)
8. Click on **ZAPISZ**

**Adding Dotpay payment method to spree store:**

1. Browse Admin Interface - http://localhost:3000/admin
2. Go to: **CONFIGURATIONS** -> **PAYMENT METHODS**
3. Click on **NEW PAYMENT METHOD**
4. Provide necessary data:
  * Provider -> 'Spree::BillingIntegration::DotpayPl'
  * Display -> 'Both'
  * Name -> 'Dotpay' (has to begin with 'dotpay', this name will be visible on checkout page)
  * Active -> set up to 'Yes'
5. Click on **CREATE**
6. Provide the rest of necessary data:
 * Dotpay account -> '123456' (your dotpay account id number without '#' symbol at the beginning)
 * Dotpay PIN code -> 'APDsdfkjsadkj2kjaskdj222jd2k1' (Pin code associated with your dotpay account)
 * Success URL -> 'your_store_domain/payments/dotpay/comeback/'' (clients will be redirected to this url after payment)
 * Currency code -> 'PLN' (payment currency, has to be the same as currency in your store)
 * Dotpay URL -> 'https://ssl.dotpay.pl/t2/' (Users will be redirectd to this address from your store to make a payment through dotpay webiste)
 * Dotpay whitelisted ip - > '195.150.9.37' (Notifications only from this ip address will be accepted)
 * Dotpay website language -> 'pl' (language for dotpay payment website, available languages: ["pl", "en", "de", "it", "fr", "es", "cz", "ru", "gb"])
 * Server -> 'live'
 * Test Mode -> set up to 'False'
7. Click on 'Update' button to save changes

TODO
----

- write automated tests

License
-------

Copyright 2016 © [Software Mansion](https://swmansion.com/). Released under the New BSD License.
