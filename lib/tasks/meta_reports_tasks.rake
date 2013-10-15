def process_value(val)
  ret = val =~ /^\$/ ? val : '#' + val
  ret.gsub /\s*\;$/, ''
end

def printfl(str)
  print str
  $stdout.flush
end

namespace :meta_reports do
  desc "dingo bingo ladooob!"
  task :export_colors => :environment do
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

    File.open("app/assets/stylesheets/lib/metareports_colors.scss", "w") do |f|
      f.puts "@import 'lib/metareports_color_variables.scss';"
      print "\tCSS classes: "
      MetaReports::Report::COLORS.each do |klass, color|
        printfl "."
        klass = klass.to_s.gsub(/___/,' ').gsub(/__/,'#').gsub(/_/,'.').gsub(/--/,':')
        if color.is_a? Array
          len = color.length
          color.each_with_index do |val, i|
            f.puts "#{klass}:nth-child(#{len}n+#{i}) { background: #{process_value(val)}; }"
          end
        else
          f.puts "#{klass} { background: #{process_value(color)}; }"
        end
      end
      puts " Done"

    end 
  end
end
