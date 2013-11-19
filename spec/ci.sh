#!/usr/bin/env sh
cd spec/dummy && echo "bundle install" && bundle install --without debug && echo "rake db:create" && bundle exec rake db:create && echo "rake db:migrate" && bundle exec rake db:migrate && cd ../../ && echo "rspec spec" && bundle exec rspec spec
