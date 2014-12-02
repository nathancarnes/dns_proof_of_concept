require_relative 'dns'

# Obviously load these from the environment or something
dnsimple = DNSimple.new dnsimple_email: 'foo@bar.com', dnsimple_password: 'totes a strong password'

# Takes an array of providers, loads up all of the domain configs, and updates
DNS.new(dnsimple).update!
