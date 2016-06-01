# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_dotpay_pl_integration'
  s.version     = '3.1.0'
  s.summary     = 'Spree integration with Dotpay payments.'
  s.description = 'Spree integration with Dotpay payments.'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Adam Winiarczyk'
  # s.email     = 'you@example.com'
  s.homepage  = 'https://github.com/espresse/spree_dotpay_pl_payment'
  s.license = 'BSD-3'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.1.0.rc1'
  s.add_dependency 'spree_frontend', '~> 3.1.0.rc1'

  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
