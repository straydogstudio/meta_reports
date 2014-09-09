module MetaReports
  class Railtie < Rails::Railtie
    initializer "meta_reports.view_helpers" do
      ActionView::Base.send :include, ReportsHelper
    end
  end
end