module MetaReports
  class Engine < ::Rails::Engine
    engine_name "meta_reports"
    isolate_namespace MetaReports

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
