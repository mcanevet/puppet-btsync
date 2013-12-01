require 'spec_helper'

describe 'btsync::config' do

  context 'when not declaring Class[btsync]' do
    it { expect { should create_class('btsync::config')}.to raise_error(Puppet::Error, /You should not declare this class explicitely, it should be done by Class\[btsync\]./) }
  end

  context 'when a parameter is passed' do
    let(:params) { {
      :foo => 'bar',
    } }

    it { expect { should create_class('btsync::config')}.to raise_error(Puppet::Error, /Invalid parameter foo/) }
  end

  context 'when using default parameters' do
    let :pre_condition do
      "class {'btsync': }"
    end

    it { should create_class('btsync::config') }
    it { should contain_file('/etc/btsync').with({
      :ensure  => :directory,
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
      :purge   => true,
      :recurse => true,
      :force   => true,
    })}
  end

  context 'when not passing a hash for instances' do
    let :pre_condition do
      "class {'btsync': instances => 'foo'}"
    end
    it { expect { should create_class('btsync::config') }.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end

  context 'when specifying an instance' do
    let :pre_condition do
      "class{'btsync': instances => { user => {} } }"
    end

    it { should create_class('btsync::config') }
    it { should contain_btsync__instance('user') }
  end

end

