require 'rails/generators'

module MetaReports
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      
      desc 'Copy meta_reports migration, models, controllers, and views.'

      def create_migration_file
        Dir.chdir(Rails.root) do
          `rake meta_reports:install:migrations`
        end
      end
      
      def install_model
        copy_file "models/report.rb", "app/models/meta_reports/report.rb"
      end

      def install_views
        directory "views", "app/views/meta_reports/reports"
      end

      def mount_engine
        insert_into_file("#{Rails.root}/config/routes.rb", :after => /routes.draw.do\n/) do
          %Q{
  # This line mounts MetaReports's routes at /reports by default.
  # This means, any requests to the /reports URL of your application will go to MetaReports::ReportsController#index.
  # If you would like to change where this extension is mounted, simply change '/reports' to something different.
  mount MetaReports::Engine => '/reports'

          }
        end
      end
    end
  end
end