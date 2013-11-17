source 'https://rubygems.org'

# Specify your gem's dependencies in meta_reports.gemspec
gemspec

case ENV['RAILS_VERSION']
when '3.1', '3.2'
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
when '4.0'
  gem 'rails'
  gem 'arel'
  gem 'activerecord-deprecated_finders'
  gem 'protected_attributes'
end

gem "jquery-rails"
gem "thin"
