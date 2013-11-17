def js_fill_in(field, val = {})
  val = val[:with]
  page.execute_script "$('##{field}').val('#{val}')"
end

def keydown(field, how_many = 1)
  how_many.times do |i|
    page.execute_script "$('##{field}').keydown()"
  end
end

def page!
  save_and_open_page
end

def wait_for_jquery(how_many = 1)
  how_many.times do |i|
    start = Time.now
    while true
      break if page.evaluate_script('$.active') == 0
      if Time.now > start + 5.seconds
        fail "wait_for_jquery failed"
      end
      sleep 0.1
    end
  end
end
