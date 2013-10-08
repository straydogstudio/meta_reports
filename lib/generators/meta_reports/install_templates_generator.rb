require 'rails/generators'

module MetaReports
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../..', __FILE__)
      
      desc 'Copy meta_reports templates.'

      def install_models
        directory "app/models/meta_reports", "app/models/meta_reports"
        copy_file "lib/generators/meta_reports/templates/models/report_non_activerecord.rb", "app/models/meta_reports/report.rb"
      end

      def install_helper
        copy_file "app/helpers/meta_reports/reports_helper.rb", "app/helpers/meta_reports/reports_helper.rb"
      end

      def install_views
        directory "lib/generators/meta_reports/templates/views/templates", "app/views/meta_reports/reports/templates"
      end
    end
  end
end