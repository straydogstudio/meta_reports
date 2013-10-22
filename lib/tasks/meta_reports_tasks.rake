def process_value(val)
  ret = val =~ /^\$/ ? val : '#' + val
  ret.gsub /\s*\;$/, ''
end

def printfl(str)
  print str
  $stdout.flush
end

namespace :meta_reports do
  desc "export both color variables and the colors sass files"
  task :export_colors => [:export_color_variables, :export_colors_only]

  desc "export the colors file"
  task :export_colors_only => :environment do
    FileUtils.mkdir_p "app/assets/stylesheets/lib"
    File.open("app/assets/stylesheets/lib/metareports_color_variables.scss", "w") do |f| 
      printfl "\tVariables: "
      MetaReports::Report::COLORS.each do |klass, value|
        printfl "."
        klass = klass.to_s
        if value.is_a? Array
          count = -1
          value.each_with_index do |val, i|
            f.puts "$#{klass}_#{i}: #{process_value(val.split.first)};"
          end
        else
          f.puts "$#{klass}: #{process_value(value.split.first)};"
        end
      end
      puts " Done"
    end
  end

  desc "export the colors variable file"
  task :export_color_variables => :environment do
    File.open("app/assets/stylesheets/lib/metareports_colors.scss", "w") do |f|
      f.puts "@import 'metareports_color_variables.scss';"
      print "\tCSS classes: "
      MetaReports::Report::COLORS.each do |klass, color|
        printfl "."
        css_klass = klass.to_s.gsub(/___/,' ').gsub(/__/,'#').gsub(/_/,'.').gsub(/--/,':')
        if color.is_a? Array
          len = color.length
          color.each_with_index do |val, i|
            f.puts "#{css_klass}:nth-child(#{len}n+#{i}) { background: $#{klass}_#{i}; }"
          end
        elsif color.to_s =~ /^\s*\$/
          f.puts "#{css_klass} { background: #{color}; }"
        else
          f.puts "#{css_klass} { background: $#{klass}; }"
        end
      end
      puts " Done"

    end 
  end
end
