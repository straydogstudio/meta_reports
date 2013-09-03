require 'spec_helper'

describe 'MetaReports dummy app' do
  before :all do
    MetaReports::Report.delete_all
    @report_moo = MetaReports::Report.create(name: 'moo', description: 'Moo, eh?', title: 'Le Moo', group: 'moo')
  end

  it "displays the index" do
    visit '/'
    page.should have_content "This page is only to see if the dummy app runs."
  end

  it "routes to the reports page" do
    visit '/meta_reports'
    page.should have_content "Le Moo"
    page.should have_content "Moo, eh?"
  end

  it "shows report using html" do
    visit "/meta_reports/#{@report_moo.id}"
    binding.pry
    page.should have_content "Le Moo"
  end
end