class Provider
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def create_or_update_record(domain, name, type, content)
    raise NotImplemented
  end

  def to_s
    raise NotImplemented
  end
end
