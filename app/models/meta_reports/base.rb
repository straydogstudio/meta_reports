class MetaReports::Base < ActiveRecord::Base
  attr_accessible :description, :direct, :group, :name, :target, :title, :views, :formats_mask, :formats
  validates_presence_of :name, :title, :group

  cattr_accessor :inline_css
  @@inline_css = true
  
  self.table_name = "meta_reports_reports"

  def self.test_report(params)
    {title: 'Test Report', subtitle: 'this is a test report', tables: {'Table 1' => [['One','Two','Three'],[1,2,3]]}}
  end

  #
  # Utility methods
  #

  FORMATS = %w[html pdf xlsx]

  def self.format_mask(format)
    1 << (FORMATS.index(format.to_s) || -1)
  end

  def self.formats_mask(*formats)
    formats.inject(0) {|mask, format| mask | (1 << (FORMATS.index(format.to_s) || -1) )}
  end

  def displays_all_formats?(*formats)
    has_all = true
    ([*formats] & FORMATS).each do |format|
      i = FORMATS.index(format.to_s)
      has_any = false if formats_mask[i] != 1
    end
    has_all
  end
  
  def displays_any_format?(*formats)
    has_any = false
    ([*formats] & FORMATS).each do |format|
      i = FORMATS.index(format.to_s)
      has_any = true if formats_mask[i] == 1
    end
    has_any
  end

  def formats=(formats)
    self.formats_mask = ([*formats] & FORMATS).inject(0) { |sum,r| sum += 1 << FORMATS.index(r) }
  end
  
  def formats
    FORMATS.reject { |r| (formats_mask || 0)[FORMATS.index(r)].zero? }
  end
  
  def format?(format)
    i = FORMATS.index(format.to_s)
    i ? (formats_mask[i] == 1) : nil
  end

  def run(params)
    report = ::MetaReports::Report.send(name, params)
    report[:id] = "report_#{name}"
    report[:report] = self
    report
  end

  def view
    ActiveRecord::Base.connection.execute("UPDATE meta_reports_reports SET views = views + 1 WHERE id = #{id}")
  end

  COLORS = {
    even:                   'efefef',
    odd:                    'ffffff',
  }

  # Sorry, God doesn't help self.helpers, which is why you need it
  def self.helpers
    ApplicationController.helpers
  end
end