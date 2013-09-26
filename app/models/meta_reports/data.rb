class MetaReports::Data
  def initialize
    @hash = {}
    yield self if block_given?
  end

  def method_missing(method, *args, &block)
    method_string = method.to_s
    if method_string =~ /^_?(.+)=$/
      @hash[$1.to_sym] = args.first
    elsif method_string =~ /^_(.*+)$/
      @hash[$1.to_sym]
    elsif @hash[method.to_sym]
      @hash[method.to_sym]
    else
      @hash.send(method, *args)
    end
  end

  def to_h
    @hash
  end
end