require 'pry'
require 'fog'
require 'yaml'

require_relative 'provider'
require_relative 'providers/dnsimple'

class DNS
  attr_reader :providers

  def initialize(*providers)
    @providers = providers
  end

  def update!
    domains.each do |domain|
      domain, records = domain.first, domain.last
      puts "Updating records for #{domain}..."

      records.each { |record| update_record record, domain }
    end
  end

  private

  def update_record(record, domain)
    name = record.first
    type = record.last.fetch('type')
    content = record.last.fetch('content')

    providers.each do |provider|
      update_record_for_provider(provider, domain, name, type, content)
    end
  end

  # TODO: ewwwwww dat argument list
  def update_record_for_provider(provider, domain, name, type, content)
    puts "Updating #{name} #{type} for #{provider}"
    provider.create_or_update_record(domain, name, type, content)
  end

  def domains
    @_domains ||= config
  end

  def config
    domains = {}

    Dir.glob('domains/*.yml').each do |file|
      domains[domain_from_filename(file)] = YAML.load_file file
    end

    domains
  end

  def domain_from_filename(file)
    file.split('/').last.gsub(/\.yml/, '')
  end
end
