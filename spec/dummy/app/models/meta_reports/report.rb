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