require 'axlsx_rails'
require 'prawn_rails'
require 'meta_reports/data'
require 'meta_reports/table'
require 'meta_reports/helper'

module MetaReports
end

require 'meta_reports/railtie' if defined?(Rails)