prawn_document(page_layout: @report[:page_layout] || :portrait, page_size: @report[:page_size] || 'LETTER') do |pdf|

render :partial => "meta_reports/reports/templates/default_header", :locals => { :pdf => pdf, :title => @report[:title], :subtitle => @report[:subtitle] }
pdf.font_size = @report[:font_size] || 8
if @report[:description]
  pdf.move_up 5
  pdf.text strip_tags(@report[:description]), align: :center
  pdf.move_down 15
end

groups = @report[:group_order] || @report[:tables].keys.sort_by {|k| k.to_s}
groups.each do |group|
  table = @report[:tables][group]
  pdf.pad_bottom(25) do
  	# pdf.group do
  		render :partial => 'meta_reports/reports/templates/default_table', :locals => {:pdf => pdf, :title => group, :table => table}
    # end
  end
end

render partial: "meta_reports/reports/templates/default_footer", locals: { pdf: pdf }

end #prawn document
