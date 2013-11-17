class MetaReports::Report < MetaReports::Base

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
 
end