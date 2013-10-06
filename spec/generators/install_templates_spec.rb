require 'spec_helper'
require 'fileutils'

describe 'meta_reports:install_templates', disabled: false do
  it "should generate views" do
    subject.should generate("app/views/meta_reports")
    subject.should generate("app/views/meta_reports/_default.html.erb")
    subject.should generate("app/views/meta_reports/_default_footer.pdf.prawn")
    subject.should generate("app/views/meta_reports/_default_table.html.erb")
    subject.should generate("app/views/meta_reports/_default_table.pdf.prawn")
    subject.should generate("app/views/meta_reports/default.html.erb")
    subject.should generate("app/views/meta_reports/default.pdf.prawn")
    subject.should generate("app/views/meta_reports/default.xlsx.axlsx")
    subject.should generate("app/helpers/meta_reports_helper.rb")
  end
end