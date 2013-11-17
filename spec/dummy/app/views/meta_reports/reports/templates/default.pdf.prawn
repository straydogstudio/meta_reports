margin = @report[:page_margin] && [*@report[:page_margin]][0,4] || nil
prawn_document(page_layout: @report[:page_orientation] || :portrait, page_size: @report[:page_size] || 'LETTER', margin: margin) do |pdf|

render :partial => "meta_reports/reports/templates/default_header", :locals => { :pdf => pdf, :title => @report[:title], :subtitle => @report[:subtitle] }
pdf.font_size = @report[:font_size] || 8
if @report[:description]
  pdf.move_up 5
  pdf.text strip_tags(@report[:description]), align: :center
  pdf.move_down 15
end

table_names = @report[:table_order] || @report[:tables].keys.sort_by {|k| k.to_s}
table_names.each do |table_name|
  table = @report[:tables][table_name]
  pdf.pad_bottom(25) do
    # TODO: provide option to 'group' all or one table
    # this forces a table to stay together on one page. throws an error if a table is larger than a page.
  	# pdf.group do
  		render :partial => 'meta_reports/reports/templates/default_table', :locals => {:pdf => pdf, :title => table_name, :table => table}
    # end
  end
end

render partial: "meta_reports/reports/templates/default_footer", locals: { pdf: pdf }

end #prawn document
