require 'spec_helper'

describe 'meta_reports:install' do
  it "should generate model" do
    subject.should generate("app/models/meta_reports/report.rb")
  end

  it "should copy migration" do
    Dir.chdir(Rails.root) do
      Dir.glob("db/migrate/*create_meta_reports_reports.meta_reports.rb").length.should == 1
    end
  end

  it "should generate views" do
    subject.should generate("app/views/meta_reports/reports")
    subject.should generate("app/views/meta_reports/reports/forms")
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