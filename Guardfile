# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2, zeus: false, parallel: false, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/support/(.+)\.rb$})                              { "spec" }
  watch(%r{^app/models/meta_reports/(.+)\.rb$})                   { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/meta_reports/(.+)_(controller)\.rb$}) { |m| "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb" }
  watch('lib/generators/meta_reports/install_generator.rb')       { "spec/generators/install_spec.rb" }
  watch('lib/generators/meta_reports/install_templates_generator.rb') { "spec/generators/install_templates_spec.rb" }
  watch('lib/tasks/meta_reports_tasks.rake')                      { "spec/tasks/meta_reports_rake_spec.rb" }
  watch('spec/dummy/app/controllers/application_controller.rb')   { "spec/controllers" }
  # dummy app 
  watch(%r{^spec/dummy/app/(.+)\.rb$})                            { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/dummy/app/(.*)(\.erb|\.haml)$})                  { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^spec/dummy/app/views/(.+)/.*\.(erb|haml)$})           { |m| "spec/requests/#{m[1]}_spec.rb" }
end