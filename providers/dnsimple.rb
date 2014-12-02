class DNSimple < Provider
  def to_s
    'DNSimple'
  end

  def create_or_update_record(domain, name, type, content)
    if (record = find_record(domain, name, type))
      id = record.fetch('record').fetch('id')
      api.update_record domain, id, { content: content }
    else
      api.create_record domain, name, type, content
    end
  end

  private

  def find_record(domain, name, type)
    records(domain).find do |record|
      record = record.fetch('record')
      record['record_type'] == type && record['name'] == name
    end
  end

  def records(domain)
    @_records ||= api.list_records(domain).data.fetch(:body)
  end

  def api
    @_api ||= Fog::DNS::DNSimple.new(options)
  end
end
