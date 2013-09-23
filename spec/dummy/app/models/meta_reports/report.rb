class MetaReports::Report < MetaReports::Base
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
          [3, "#{params[:moo_type]} Moo", 'No Way!'],
        ]
      }
    }
  end
 
end