@reports ||= [@report]
@report  ||= @reports.first
margin = @report[:page_margin] && [*@report[:page_margin]][0,4] || nil
prawn_document(page_layout: @report[:page_orientation] || :portrait, page_size: @report[:page_size] || 'LETTER', margin: margin) do |pdf|

  @reports.each do |report|
    unless report == @report
      margin = report[:page_margin] && [*report[:page_margin]][0,4] || nil
      pdf.start_new_page layout: report[:page_orientation] || :portrait, size: report[:page_size] || 'LETTER', margin: margin 
    end

    render :partial => "meta_reports/default_header", :locals => { :pdf => pdf, :title => report[:title], :subtitle => report[:subtitle] }
    pdf.font_size = report[:font_size] || 8
    if report[:description]
      pdf.move_up 5
      pdf.text strip_tags(report[:description]), align: :center
      pdf.move_down 15
    end

    table_names = report[:table_order] || report[:tables].keys.sort_by {|k| k.to_s}
    table_names.each do |table_name|
      table = report[:tables][table_name]
      pdf.pad_bottom(25) do
        if table[:group]
          pdf.group do #if the table is larger than a page this will throw an error
            render :partial => 'meta_reports/default_table', :locals => {:pdf => pdf, :title => table_name, :table => table}
          end
        else
          render :partial => 'meta_reports/default_table', :locals => {:pdf => pdf, :title => table_name, :table => table}
        end
      end
    end

    render partial: "meta_reports/default_footer", locals: { pdf: pdf }

  end #each report
end #prawn document
