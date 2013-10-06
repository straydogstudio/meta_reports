require 'rails/generators'

module MetaReports
  module Generators
    class InstallTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      
      desc 'Copy meta_reports templates.'

      def install_views
        directory "views", "app/views/meta_reports"
      end
    end
  end
end