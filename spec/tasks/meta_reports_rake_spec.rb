require 'spec_helper'
require 'rake'
require 'fileutils'

describe 'rake tasks' do
  describe 'meta_reports:export_colors' do
    before :all do
      Rake.application.rake_require 'tasks/meta_reports_tasks'
      Rake::Task.define_task(:environment)
      Dir.chdir(Rails.root) do
        Dir.glob("app/assets/stylesheets/lib/*").map {|f| File.unlink(f)}
        Rake::Task["meta_reports:export_colors"].reenable
        Rake.application.invoke_task "meta_reports:export_colors"
      end
    end
      # FileUtils.rm_r("app/assets/stylesheets/lib")

    it "exports two files" do
      Dir.chdir(Rails.root) do
        Dir.glob("app/assets/stylesheets/lib/*").length.should == 2
      end
    end

    it "exports colors" do
      Dir.chdir(Rails.root) do
        puts Dir.pwd
        css = File.open("app/assets/stylesheets/lib/metareports_colors.scss",'rb') {|f| f.read }
        css.should == "@import 'metareports_color_variables.scss';
.even { background: $_even; }
.odd { background: $_odd; }
.yellow:nth-child(4n+0) { background: $_yellow_0; }
.yellow:nth-child(4n+1) { background: $_yellow_1; }
.yellow:nth-child(4n+2) { background: $_yellow_2; }
.yellow:nth-child(4n+3) { background: $_yellow_3; }
tr .highlight { background: $_yellow_1 !important; }
a:hover:nth-child(2n+0) { background: $a--hover_0; }
a:hover:nth-child(2n+1) { background: $a--hover_1; }
"
      end
    end

    it "exports variables" do
      Dir.chdir(Rails.root) do
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
      end
    end
  end
end