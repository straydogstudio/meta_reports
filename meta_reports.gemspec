$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "meta_reports/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = "meta_reports"
  s.version       = MetaReports::VERSION
  s.authors       = ["Noel Peden"]
  s.email         = ["noel@peden.biz"]
  s.description   = %q{Meta Reports provides a meta language and data structure to create a 'meta' report. This report can then be exported into any format desired. MR provides HTML, PDF, and XLSX exports built in.}
  s.summary       = %q{A meta report structure independent of any format, that can then be exported to multiple formats.}
  s.homepage      = "http://github.com/straydogstudio/meta_reports"
  s.license       = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files    = Dir["spec/**/*"] + ['Guardfile']

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency "acts_as_xlsx"
  s.add_dependency "prawn"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "capybara"
  s.add_development_dependency "roo", '1.10.1'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "growl"
  s.add_development_dependency "rb-fsevent"
end
