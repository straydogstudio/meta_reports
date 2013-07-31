require 'rails/generators'

module MetaReports
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def install_model
        #install decorator in app/models/meta_reports/meta_report.rb
      end

      def install_views
        #install default views and templates
      end
    end
  end
end