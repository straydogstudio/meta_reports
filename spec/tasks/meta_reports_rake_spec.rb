require 'spec_helper'
require 'rake'
require 'fileutils'

describe 'meta_reports rake tasks' do
  describe 'meta_reports:export_colors' do
    before :all do
      Rake.application.rake_require 'tasks/meta_reports_tasks'
      Rake::Task.define_task(:environment)
    end

    it "should export colors" do
      FileUtils.rm_r("app/assets/stylesheets/lib") if File.exists?("app/assets/stylesheets/lib")
      Rake::Task["meta_reports:export_colors"].reenable
      Rake.application.invoke_task "meta_reports:export_colors"
      Dir.glob("app/assets/stylesheets/lib/*").length.should == 2
      css = File.open("app/assets/stylesheets/lib/metareports_colors.scss",'rb') {|f| f.read }
      css.should == "@import 'lib/metareports_color_variables.scss';
.even { background: #efefef; }
.odd { background: #ffffff; }
.yellow:nth-child(4n+0) { background: #ffffaa; }
.yellow:nth-child(4n+1) { background: #ffffcc; }
.yellow:nth-child(4n+2) { background: #f9f9a4; }
.yellow:nth-child(4n+3) { background: #f9f9c6; }
tr .highlight { background: $_yellow_1 !important; }
a:hover:nth-child(2n+0) { background: #ffcccc; }
a:hover:nth-child(2n+1) { background: #ffc5c5; }
"
      variables = File.open("app/assets/stylesheets/lib/metareports_color_variables.scss",'rb') {|f| f.read}
      variables.should == "$_even: #efefef;
$_odd: #ffffff;
$_yellow_0: #ffffaa;
$_yellow_1: #ffffcc;
$_yellow_2: #f9f9a4;
$_yellow_3: #f9f9c6;
$tr____highlight: $_yellow_1;
$a--hover_0: #ffcccc;
$a--hover_1: #ffc5c5;
"
      FileUtils.rm_r("app/assets/stylesheets/lib")
    end
  end
end