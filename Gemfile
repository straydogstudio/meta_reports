source 'https://rubygems.org'

# Specify your gem's dependencies in meta_reports.gemspec
gemspec

case ENV['RAILS_VERSION']
when '3.1', '3.2'
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
when '4.0'
  gem 'rails'
  gem 'arel',  github: 'rails/arel'
  gem 'activerecord-deprecated_finders', github: 'rails/activerecord-deprecated_finders'
  gem 'protected_attributes', github: 'rails/protected_attributes'
end

# jquery-rails is used by the dummy application
gem "jquery-rails"
gem "thin"
