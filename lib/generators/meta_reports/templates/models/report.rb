class MetaReports::Report < MetaReports::Base

  #
  # Shared colors. The key is the class name, value is RGB in hex format
  #

  COLORS = {
    even:                   'efefef',
    odd:                    'ffffff',
  }


  #
  # Reports
  #

  def self.example_report(params)
    {title: 'Example Report', subtitle: 'this is a test report', tables: {'Table 1' => [['One','Two','Three'],[1,2,3]]}}
    MetaReports::Data.new do |d|
      d.title = 'Example Report'
      d.subtitle = 'Of the Testing Kind'
      d.description = 'This is a test report.'
      d.tables["Table 1"] = MetaReports::Table.new do |t|
        t << ['One', 'Two', 'Three']
        t << [1, 2, 3]
      end
    end
  end

end