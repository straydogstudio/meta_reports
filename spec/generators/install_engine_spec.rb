require 'spec_helper'
require 'fileutils'

describe 'meta_reports:install_engine', disabled: false do
  before :all do
    Dir.chdir(Rails.root) do
      FileUtils.cp "config/routes_empty.rb", "config/routes.rb"
      Dir.glob("db/migrate/*create_meta_reports_reports.meta_reports.rb").each do |migration|
        File.unlink(migration)
      end
    end
  end

  after :all do
    Dir.chdir(Rails.root) do
      FileUtils.cp "config/routes_original.rb", "config/routes.rb"
      migrations = Dir.glob("db/migrate/*create_meta_reports_reports.meta_reports.rb")
      migrations.length.should == 1
      migrations.each {|m| File.unlink(m) }
    end
  end

  it "should generate model" do
    subject.should generate("app/models/meta_reports/report.rb")
  end

  it "should modify the routes file" do
    Dir.chdir(Rails.root) do
      open("config/routes.rb").grep(/MetaReports::Engine/).should be
    end
  end

  it "should generate views" do
    subject.should generate("app/views/meta_reports/reports")
    subject.should generate("app/views/meta_reports/reports/forms")
    subject.should generate("app/views/meta_reports/reports/forms/form.html.erb")
    subject.should generate("app/views/meta_reports/reports/forms/_form_example.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates")
    subject.should generate("app/views/meta_reports/reports/templates/_default.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/_default_footer.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/_default_table.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/_default_table.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/default.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/default.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/default.xlsx.axlsx")
    subject.should generate("app/views/meta_reports/reports/_form.html.erb")
    subject.should generate("app/views/meta_reports/reports/edit.html.erb")
    subject.should generate("app/views/meta_reports/reports/index.html.erb")
    subject.should generate("app/views/meta_reports/reports/new.html.erb")
  end
end