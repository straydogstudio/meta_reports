require "meta_reports/engine"

module MetaReports

  def self.setup
    yield self
  end
end
