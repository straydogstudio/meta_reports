class MetaReports::Report

  #
  # Shared colors. The key is the class name, value is RGB in hex format
  #
  # When you run the meta_reports:export_colors Rake task, the key changes as follows: 
  #  * In the SASS CSS file:
  #    - '___' will be changed to ' '
  #    -  '__' will be changed to '#'
  #    -   '_' will be changed to '.'
  #    -  '--' will be changed to ':'
  #    - an array of values will be changed to nth-child rules for consecutive rows
  #  * In the SASS variables file:
  #    - the variable name will be the same as the key
  #    - an array of values will be changed into variables whose name is the class name plus a numerical suffix for each entry
  #
  # Example: 'tr____highlight' is 'tr .highlight {}' in CSS, and $tr____highlight as a SASS variable.
  #

  COLORS = {
    _even:                   'efefef',
    _odd:                    'ffffff',
    _yellow:                 ['ffffaa', 'ffffcc', 'f9f9a4', 'f9f9c6'],
    tr____highlight:          '$_yellow_1 !important',
    'a--hover' =>            ['ffcccc', 'ffc5c5']
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