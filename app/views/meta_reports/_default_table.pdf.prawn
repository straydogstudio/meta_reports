if defined?(title)
  pdf.text title.to_s, :align => :center, :style => :bold, :size => 13
end
styling = {}
column_widths = {} if !defined?(column_widths) || column_widths.blank?
font_size = table[:font_size] || 8
table_header = table[:table_header] != false
row_offset = table_header ? 1 : 0
pdf.table prep_pdf_table(table, styling), :header => table_header, :row_colors => ["EEEEEE", "FFFFFF"], :width => pdf.bounds.width, :cell_style => {:padding => 2, :size => font_size, :align => :center} do |t|
  t.cells.borders = []
  t.style t.row(0), :borders => [:bottom], :background_color => "DDDDDD", :font_style => :bold
  [:left, :center, :right].each do |style|
    styling[style].to_a.each do |cell|
      t.row(cell[0]).column(cell[1]).align = style
    end
  end
  styling[:bold].to_a.each do |cell|
    t.style t.row(cell[0]).column(cell[1]), :font_style => :bold
  end
  styling[:row_colors].each do |row, color|
    t.style t.row(row+row_offset), :background_color => color
  end
  styling[:cell_bg_colors].to_a.each do |cell|
    t.style t.row(cell[0]).column(cell[1]), :background_color => cell[2]
  end
  if styling[:column_widths]
    t.column_widths = styling[:column_widths]
  else
    t.column_widths = column_widths
  end
  # if totals row? how specify or check?
  # t.style t.row(-1), :font_style => :bold
end
