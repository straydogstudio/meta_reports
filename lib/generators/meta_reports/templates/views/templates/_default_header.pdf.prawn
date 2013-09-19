pdf.text 'Company Name', :style => :bold, :size => 9
pdf.text '1234 Address', :size => 7
pdf.text 'City, ST 12345', :size => 7
pdf.text '(123) 456-7890', :size => 8
# pdf.image 'image_file', width: 60, position: :right, vposition: 0


pdf.move_up 65
pdf.pad_bottom(10) do
  pdf.text title, :size => 18, :align => :center if title
  pdf.text subtitle, :size => 12, :align => :center if subtitle
end
pdf.move_down 7
