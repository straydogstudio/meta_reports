module MetaReports
  module ReportsHelper
    def html_cell(cell, tag = :td)
      if cell.is_a? Hash
        tags = cell.reject {|k,v| k == :content || k == :html}
        tags[:class] ||= 'textcenter'
        content_tag tag, (cell[:html] || cell[:content]).to_s.html_safe, tags
      elsif cell.is_a? Array
      else
        content_tag tag, cell, :class => 'textcenter'
      end
    end

    def prep_pdf_table(table, styling)
      opts = table.last.is_a?(Hash) ? table.pop : {}
      styling[:column_widths] = opts[:column_widths] if opts[:column_widths]
      row_classes = opts[:row_classes] || {}
      row_colors = {}
      row_classes.each do |i, klass|
        if color = Setting.tr_color(klass, i)
          row_colors[i] = color
        end
      end
      styling[:row_colors] = row_colors
      table.each_index do |i|
        table[i].each_index do |j|
          if table[i][j].is_a? Hash
            [:html, :title, :id].each {|sym| table[i][j].delete(sym)}
            _class = table[i][j].delete(:class)
            [:right, :left, :center].each do |sym|
              set_style(styling, sym, i, j) if _class =~ /\b#{sym}\b|[^a-z]#{sym}/i
            end
            if _class =~ /\bbold\b|\bstrong\b/
              set_style(styling, :bold, i, j)
            end
            unless table[i][j][:image]
              table[i][j][:content] = table[i][j][:content].to_s unless table[i][j][:content].is_a? String
            end
          end
        end
      end
      table
    end

    def prep_xlsx_table(table, styling)
      table.each_index do |i|
        table[i].each_index do |j|
          if table[i][j].nil?
            table[i][j] = ''
          elsif table[i][j].is_a? Hash
            _class = table[i][j][:class]
            [:right, :left, :center].each do |sym|
              set_style(styling, sym, i, j) if _class =~ /\b#{sym}\b|[^a-z]#{sym}/i
            end
            if _class =~ /\bbold\b|\bstrong\b/
              set_style(styling, :bold, i, j)
            end
            table[i][j] = table[i][j][:content].to_s
          end
        end
      end
      table
    end

    def report_link(report, title = report.title)
      if report.direct
        content_tag :span do
          links = []
          if report.format? :html
            links << link_to(title, meta_reports.short_show_path(report), target: '_blank')
          elsif report.format? :pdf
            links << link_to(title, meta_reports.short_show_path(report, format: :pdf), target: '_blank')
          elsif report.format? :xlsx
            links << link_to(title, meta_reports.short_show_path(report, format: :xlsx), target: '_blank')
          end
          if report.format? :pdf
            links << link_to(image_tag('meta_reports/print.png'), meta_reports.short_show_path(report, format: :pdf), target: '_blank')
          end
          if report.format? :xlsx
            links << link_to(image_tag('meta_reports/spreadsheet.png'), meta_reports.short_show_path(report, format: :xlsx), target: '_blank')
          end
          links.join(' ').html_safe
        end
      else
        content_tag :span do
         link_to report.title, meta_reports.short_form_path(report)
        end
      end
    end

    def report_alt_links(report, params)
      links = []
      if report.format? :pdf
        links << link_to(image_tag('meta_reports/print.png'), params.merge({:format => :pdf}), :target => '_blank')
      end
      if report.format? :xlsx
        links << link_to(image_tag('meta_reports/spreadsheet.png'), params.merge({:format => :xlsx}), :target => '_blank')
      end
      links.join(' ').html_safe
    end

    def set_style(styling, style, row, col)
      styling[style] ||= []
      styling[style] << [row,col]
    end

    def to_xls_col(column)
      index = column.to_i.abs
      chars = []
      while index >= 26 do
        chars << ((index % 26) + 65).chr
        index = (index / 26).to_i - 1
      end
      chars << (index + 65).chr
      chars.reverse.join
    end

  end
end
