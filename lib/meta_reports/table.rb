class MetaReports::Table
  def initialize
    @data = []
    @options = {row_classes: {}}
    yield self if block_given?
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

  # options methods

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

  # data methods

  def <<(val)
    @data << val
  end

  def +(arr)
    @data += arr
  end

  def first
    @data.first
  end

  def last
    @data.last
  end

  def length
    @data.length
  end

  def pop
    @data.pop
  end

  def push(val)
    @data.push(val)
  end

  def shift
    @data.shift
  end

  def to_a
    @data
  end

  def data=(value)
    @data = value
  end

  def unshift(val)
    @data.unshift(val)
  end

  alias_method :data, :to_a
end