require 'rails/generators'

module MetaReports
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../..', __FILE__)
      
      desc 'Copy meta_reports templates.'

      def install_helper
        copy_file "app/helpers/meta_reports/reports_helper.rb", "app/helpers/meta_reports_helper.rb"
      end

      def install_views
        directory "lib/generators/meta_reports/templates/views/templates", "app/views/meta_reports"
      end
    end
  end
end