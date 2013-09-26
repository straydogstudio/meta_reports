class MetaReports::Data
  def initialize
    @hash = {}
    yield self if block_given?
  end

  def method_missing(method, *args, &block)
    if method.to_s =~ /^(.+)=$/
      @hash[$1.to_sym] = args.first
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