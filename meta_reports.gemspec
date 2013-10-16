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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files    = Dir["spec/**/*"] + ['Guardfile']

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "axlsx_rails"
  s.add_dependency "prawn_rails"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "capybara"
  s.add_development_dependency "roo"
  s.add_development_dependency "rubyzip"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "growl"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "genspec"
  s.add_development_dependency 'pdf-inspector', '~> 1.1.0'
  s.add_development_dependency "coveralls"
  s.add_development_dependency "sass-rails"
end
