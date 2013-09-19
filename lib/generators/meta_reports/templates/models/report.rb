class MetaReports::Report < MetaReports::Base

  #
  # Reports
  #

  def self.example_report(params)
    {title: 'Example Report', subtitle: 'this is a test report', tables: {'Table 1' => [['One','Two','Three'],[1,2,3]]}}
  end

end