pdf.font_size = 8

time_string = Time.now.strftime("Generated on %-m/%-d/%y at %l:%M %p")
absolute_bottom = pdf.bounds.absolute_bottom
time_y = 14 - absolute_bottom
pdf.repeat :all do
  pdf.draw_text time_string, at: [0,time_y]
end

string = "Page <page> of <total>"
options = { :at => [pdf.bounds.right - 150, 20-absolute_bottom], :width => 150, :align => :right }
pdf.number_pages string, options