module MetaReports
  module ReportsHelper
    def meta_report_color(klass, row = 0)
      @meta_reports_colors ||= {}
      @meta_reports_colors[klass.to_sym] ||= begin
        color = MetaReports::Report::COLORS[klass.to_sym]
        return nil unless color
        if color.is_a? Array
          # the trailing split first is to drop any !important directive
          color = color[row%color.length].to_s.split.first 
        end
        if color.gsub!(/^\$/, '') # we have a variable
          index = 0
          index = $1 if color.gsub!(/_(\d+)$/,'')
          color = meta_report_color(color, index)
        end
        color
      end
    end

    def convert_margins_to_xlsx(margins)
      margins = [*margins].compact.map {|val| val/72.0}
      page_margins = {}
      unless margins.blank?
        len = margins.length
        [:top, :right, :bottom, :left].each_with_index { |dir, i| page_margins[dir] = margins[i%len] }
        if len == 6
          page_margins[:header] = margins[5]
          page_margins[:footer] = margins[6]
        end
      end
      page_margins
    end

    def html_cell(cell, options = {})
      tag = options[:tag] || :td
      options[:inline_css].nil? && options[:inline_css] = true
      if cell.is_a? Hash
        tags = cell.reject {|k,v| k == :content || k == :html}
        tags[:class] ||= options[:default_class]
        if options[:inline_css]
          color = nil
          tags[:class].split(/\s+/).each do |token|
            if color = meta_report_color(token)
              break
            end
          end
          tags[:style] = "background-color: ##{color}"
        end
        content_tag tag, (cell[:html] || cell[:content]).to_s.html_safe, tags
      elsif cell.is_a? Array
      else
        content_tag(tag, cell, :class => options[:default_class])
      end
    end

    def prep_pdf_table(table, styling)
      if table.is_a?(Array)
        opts = table.last.is_a?(Hash) && table.pop || {}
        data = table
      else
        data = table.to_a
        opts = table.options
      end
      styling[:column_widths] = opts[:column_widths] if opts[:column_widths]
      row_classes = opts[:row_classes] || {}
      row_colors = {}
      row_classes.each do |i, klass|
        if color = meta_report_color(klass, i)
          row_colors[i] = color
        end
      end
      styling[:row_colors] = row_colors
      data.each_index do |i|
        data[i].each_index do |j|
          if data[i][j].is_a? Hash
            [:html, :title, :id].each {|sym| data[i][j].delete(sym)}
            _class = data[i][j].delete(:class)
            unless _class.blank?
              [:right, :left, :center].each do |sym|
                set_style(styling, sym, i, j) if _class =~ /\b#{sym}\b|[^a-z]#{sym}/i
              end
              if _class =~ /\bbold\b|\bstrong\b/
                set_style(styling, :bold, i, j)
              end
              _class.to_s.split(/\s+/).each do |token|
                if color = meta_report_color(token)
                  set_style(styling, :cell_bg_colors, i, j, color)
                  break
                end
              end
            end
            unless data[i][j][:image] || data[i][j][:content].is_a?(String)
              data[i][j][:content] = data[i][j][:content].to_s
            end
          elsif !data[i][j].is_a?(String)
            data[i][j] = data[i][j].to_s
          end
        end
      end
      data
    end

    def prep_xlsx_table(table, styling)
      data = table.to_a
      data.each_index do |i|
        data[i].each_index do |j|
          if data[i][j].nil?
            data[i][j] = ''
          elsif data[i][j].is_a? Hash
            _class = data[i][j][:class]
            [:right, :left, :center].each do |sym|
              set_style(styling, sym, i, j) if _class =~ /\b#{sym}\b|[^a-z]#{sym}/i
            end
            if _class =~ /\bbold\b|\bstrong\b/
              set_style(styling, :bold, i, j)
            end
            data[i][j] = data[i][j][:content].to_s
          end
        end
      end
      data
    end

    def meta_report_link(report, title = report.title)
      return nil unless report
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
         link_to title, report
        end
      end
    end

    def meta_report_alt_links(report, params)
      return nil unless report
      links = []
      if report.format? :pdf
        links << link_to(image_tag('meta_reports/print.png'), params.merge({:format => :pdf}), :target => '_blank')
      end
      if report.format? :xlsx
        links << link_to(image_tag('meta_reports/spreadsheet.png'), params.merge({:format => :xlsx}), :target => '_blank')
      end
      links.join(' ').html_safe
    end

    def set_style(styling, style, row, col, val = nil)
      styling[style] ||= []
      styling[style] << (val ? [row,col,val] : [row,col])
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
