require 'rails/generators'

module MetaReports
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('../../../..', __FILE__)
      
      desc 'Copy meta_reports templates.'

      def install_models
        directory "app/models/meta_reports", "app/models/meta_reports"
      end

      def install_views
        directory "app/views/meta_reports", "app/views/meta_reports"
      end
    end
  end
end