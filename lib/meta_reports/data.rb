module MetaReports
  class Data
    def initialize
      @hash = {tables: {}}
      @id = rand(10000)
      yield self if block_given?
      self
    end

    def method_missing(method, *args, &block)
      method_string = method.to_s
      if method_string =~ /^(.+)=$/
        @hash[$1.to_sym] = args.first
      elsif @hash[method.to_sym]
        @hash[method.to_sym]
      else
        @hash.send(method, *args)
      end
    end

    def [](key)
      @hash[key]
    end

    def []=(key, value)
      @hash[key] = value
    end

    def id
      @hash[:id] || @hash[:title].to_s.downcase.gsub(/[^a-z]/,'_') || @id
    end

    def tables
      @hash[:tables]
    end

    def tables=(value)
      @hash[:tables] = value
    end

    def to_h
      @hash
    end
  end
end