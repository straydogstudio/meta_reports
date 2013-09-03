module MetaReports
  module ReportsHelper
    def html_cell(cell, tag = :td)
      if cell.is_a? Hash
        tags = cell.reject {|k,v| k == :content || k == :link}
        tags[:class] ||= 'textcenter'
        content_tag tag, (cell[:link] || cell[:content]).to_s.html_safe, tags
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
            [:link, :title, :id].each {|sym| table[i][j].delete(sym)}
            _class = table[i][j].delete(:class)
            if _class =~ /\btext(\w+)\b/
              set_style(styling, $1.to_sym, i, j)
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
            {:right => /\bright\b/, :left => /\bleft\b/, :center => /\bcenter\b/}.each do |sym, pattern|
              set_style(styling, sym, i, j) if _class =~ pattern
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

    def report_link(report)
      if report.direct
        content_tag :span do
          links = []
          if report.format? :html
            links << link_to(report.title, "/reports/#{report.name}", target: '_blank')
          elsif report.format? :pdf
            links << link_to(report.title, "/reports/#{report.name}.pdf", target: '_blank')
          elsif report.format? :xlsx
            links << link_to(report.title, "/reports/#{report.name}.xlsx", target: '_blank')
          end
          if report.format? :pdf
            links << link_to('PDF', "/reports/#{report.name}.pdf", target: '_blank')
          end
          if report.format? :xlsx
            links << link_to('XLSX', "/reports/#{report.name}.xlsx", target: '_blank')
          end
          links.join(' ').html_safe
        end
      else
        content_tag :span do
         link_to report.title, "/reports/form/#{report.id}?modal=true", :remote => true
        end
      end
    end

    def report_alt_links(report, params)
      links = []
      if report.format? :pdf
        links << link_to('PDF', params.merge({:format => :pdf}), :target => '_blank')
      end
      if report.format? :xlsx
        links << link_to('XLSX', params.merge({:format => :xlsx}), :target => '_blank')
      end
      links.join(' ').html_safe
    end

    def set_style(styling, style, row, col)
      styling[style] ||= []
      styling[style] << [row,col]
    end

  end
end
