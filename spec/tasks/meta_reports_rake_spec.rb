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
tr.even { background: $even; }
tr.odd { background: $odd; }
tr.yellow:nth-child(4n+0) { background: $yellow_0; }
tr.yellow:nth-child(4n+1) { background: $yellow_1; }
tr.yellow:nth-child(4n+2) { background: $yellow_2; }
tr.yellow:nth-child(4n+3) { background: $yellow_3; }
tr.highlight { background: $yellow_1 !important; }
"
      end
    end

    it "exports variables" do
      Dir.chdir(Rails.root) do
        variables = File.open("app/assets/stylesheets/lib/metareports_color_variables.scss",'rb') {|f| f.read}
        variables.should == "$even: #efefef;
$odd: #ffffff;
$yellow_0: #ffffaa;
$yellow_1: #ffffcc;
$yellow_2: #f9f9a4;
$yellow_3: #f9f9c6;
$highlight: $yellow_1;
"
      end
    end
  end
end