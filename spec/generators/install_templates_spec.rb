require 'spec_helper'
require 'fileutils'

describe 'meta_reports:install_templates', disabled: false do
  it "should generate views" do
    subject.should generate("app/models/meta_reports")
    subject.should generate("app/models/meta_reports/base.rb")
    subject.should generate("app/models/meta_reports/data.rb")
    subject.should generate("app/models/meta_reports/report.rb")
    subject.should generate("app/models/meta_reports/table.rb")
    subject.should generate("app/views/meta_reports/reports/templates")
    subject.should generate("app/views/meta_reports/reports/templates/_default.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/_default_footer.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/_default_table.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/_default_table.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/default.html.erb")
    subject.should generate("app/views/meta_reports/reports/templates/default.pdf.prawn")
    subject.should generate("app/views/meta_reports/reports/templates/default.xlsx.axlsx")
    subject.should generate("app/helpers/meta_reports/reports_helper.rb")
  end
end