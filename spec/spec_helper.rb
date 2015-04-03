require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end

RSpec.configure do |c|
  c.default_facts = {
    :os_maj_version => '6',
    :puppetversion  => '3.7.5',
    :kernel         => 'Linux',
    :path           => '/bin:/usr/bin',
  }
end
