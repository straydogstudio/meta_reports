# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, zeus: false, parallel: false, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/dummy/app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/dummy/app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^spec/dummy/app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                             { "spec" }
  watch('lib/generators/meta_reports/install_generator.rb')      { "spec/generators/install_spec.rb" }
  watch('spec/dummy/app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^spec/dummy/app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end