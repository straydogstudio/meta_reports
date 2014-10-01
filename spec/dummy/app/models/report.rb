class Report < ActiveRecord::Base
  attr_accessible :name, :description, :title, :group, :formats_mask

  def self.moo(params)
    MetaReports::Data.new do |d|
      d.title = 'Le Moo'
      d.subtitle = 'Ahem'
      d.tables["The Big Moo"] = MetaReports::Table.new do |t|
        t << ['Number', 'Title', 'Hey']
        t << [1, 'Ode to Moo', 'Ow']
        t << [2, 'Odious Moo', 'Eww']
        t << [3, "#{params[:moo_type]} Moo", 'No Way!']
      end
    end
  end

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
    report = Report.send(name, params)
    report[:id] = "report_#{name}"
    report[:report] = self
    report
  end

  def view
    ActiveRecord::Base.connection.execute("UPDATE reports SET views = views + 1 WHERE id = #{id}")
  end
end