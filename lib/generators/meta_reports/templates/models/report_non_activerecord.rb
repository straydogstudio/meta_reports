class MetaReports::Report

  #
  # Shared colors. The key is the class name, value is RGB in hex format
  #
  # Example: "highlight: 'ffcccc'" is 'tr.highlight {background: #ffcccc}' in CSS, and "$highlight: #ffcccc;"" as a SASS variable.
  #

  COLORS = {
    even:                   'efefef',
    odd:                    'ffffff',
    yellow:                 ['ffffaa', 'ffffcc', 'f9f9a4', 'f9f9c6'],
    highlight:          '$yellow_1 !important',
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
        t << [4, "#{params[:disco]} Moo", 'No Way!']
      end
    end
  end

end