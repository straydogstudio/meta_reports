#!/usr/bin/env sh
cd spec/dummy && echo "bundle install" && bundle install --without debug && echo "rake db:create" && bundle exec rake db:create && echo "rake db:migrate" && bundle exec rake db:migrate && rm -rf app/models/meta_reports/color.rb app/views/meta_reports && bundle exec rails g meta_reports:install_templates && cd ../../ && echo "rspec spec" && bundle exec rspec spec
