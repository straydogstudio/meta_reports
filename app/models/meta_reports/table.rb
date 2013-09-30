class MetaReports::Table
  def initialize
    @data = []
    @options = {row_classes: {}}
    yield self if block_given?
  end

  def length
    @data.length
  end

  def method_missing(method, *args, &block)
    method_string = method.to_s
    if method_string =~ /^(.+)=$/
      @options[$1.to_sym] = args.first
    elsif @options[method.to_sym]
      @options[method.to_sym]
    else
      super
    end
  end

  def [](key)
    @options[key]
  end

  def []=(key,val)
    @options[key] = val
  end

  def options
    @options
  end

  def row_classes
    @options[:row_classes]
  end

  def data
    @data
  end
  
  def to_a
    @data
  end

  def <<(row)
    @data << row
  end

  def +(arr)
    @data += arr
  end

  alias_method :data, :to_a
end