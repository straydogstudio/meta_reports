class MetaReports::Report < ActiveRecord::Base
  attr_accessible :description, :direct, :group, :name, :target, :title, :views, :formats_mask
  validates_presence_of :name, :title, :group

  #
  # Reports
  #

  def self.moo(params)
    {
      title: 'Le Moo',
      subtitle: 'Ahem',
      tables: {
        "The Big Moo" => [
          ['Number', 'Title', 'Hey'],
          [1, 'Ode to Moo', 'Ow'],
          [2, 'Odious Moo', 'Eww'],
        ]
      }
    }
  end
 
  def self.test_report(params)
    {title: 'Test Report', subtitle: 'this is a test report', tables: {'Table 1' => [['One','Two','Three'],[1,2,3]]}}
  end

  #
  # Utility methods
  #

  FORMATS = %w[html pdf xlsx]

  def run(params)
    report = ::MetaReports::Report.send(name, params)
    report[:id] = "report_#{name}"
    report[:report] = self
    report
  end

  def view
    connection.execute("UPDATE meta_reports_reports SET views = views + 1 WHERE id = #{id}")
  end

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
end