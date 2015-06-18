require 'rspec-puppet'
require 'puppet_x/brocade/transport'
require 'puppet/util/network_device/transport/ssh'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
NOOP_HASH = { :noop => false}

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.environmentpath = File.join(Dir.pwd, 'spec')
end