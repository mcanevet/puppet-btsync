require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.include PuppetlabsSpec::Files

  c.before :each do
    # Store any environment variables away to be restored later
    @old_env = {}
    ENV.each_key {|k| @old_env[k] = ENV[k]}

    c.strict_variables = Gem::Version.new(Puppet.version) >= Gem::Version.new('3.5')
    Puppet.features.stubs(:root?).returns(true)
  end

  c.after :each do
    PuppetlabsSpec::Files.cleanup
  end
end
