require 'spec_helper'

describe 'MetaReports dummy app' do
  before :all do
    MetaReports::Report.delete_all
    @report_moo = MetaReports::Report.create(name: 'moo', description: 'Moo, eh?', title: 'Le Moo', group: 'moo', formats_mask: 7)
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
    page.should have_content "Ode to Moo"
  end

  it "edits report" do
    visit "/meta_reports/#{@report_moo.id}/edit"
    page.should have_content "Moo, eh?"
  end

  it "shows new report form" do
    visit "/meta_reports/new"
    page.should have_content "New report"
  end

  it "downloads report using pdf" do
    visit "/meta_reports/#{@report_moo.id}.pdf"
    response_headers["Content-Type"].should == "application/pdf; charset=utf-8"
    output = PDF::Inspector::Text.analyze(page.source)
    output.strings.should == ["Company Name", "1234 Address", "City, ST 12345", "(123) 456-7890", "Le Moo", "Ahem", "The Big Moo", "Number", "Title", "Hey", "1", "Ode to Moo", "Ow", "2", "Odious Moo", "Eww", "3", "Moo", "No Way!", "Page 1 of 1"]
  end

  it "downloads report using xlsx" do
    visit "/meta_reports/#{@report_moo.id}.xlsx"
    page.response_headers['Content-Type'].should == Mime::XLSX.to_s + "; charset=utf-8"
    File.open('/tmp/meta_reports.xlsx', 'w') {|f| f.write(page.source) }
    wb = nil
    expect{ wb = Roo::Excelx.new('/tmp/meta_reports.xlsx') }.to_not raise_error
    wb.cell(3,1).should == 'Le Moo'
    wb.cell(6,1).should == 'The Big Moo'
    wb.cell(9,2).should == 'Odious Moo'
  end
end