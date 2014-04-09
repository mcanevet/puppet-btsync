require 'spec_helper'

describe 'btsync' do

  let (:facts) { {
    :puppet_vardir => '/var/lib/puppet',
  } }

  context 'when enable is not a boolean' do
    let(:params) { {
      :enable => 'foo',
    } }
    it { expect { should compile }.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end

  context 'when start is not a boolean' do
    let(:params) { {
      :start => 'foo',
    } }
    it { expect { should compile }.to raise_error(Puppet::Error, /"foo" is not a boolean/) }
  end

  context 'when instances is not a hash' do
    let(:params) { {
      :instances => 'foo',
    } }
    it { expect { should compile }.to raise_error(Puppet::Error, /"foo" is not a Hash/) }
  end

  context 'when using default parameters' do
    let(:params) { { } }

    it { should compile.with_all_deps }

    it { should create_class('btsync')\
      .with_version('present')\
      .with_enable(true)\
      .with_start(true)\
      .with_instances({}) }

    it { should contain_class('btsync::install') }
    it { should contain_package('btsync').with({
      :ensure => :present,
    })}

    it { should contain_class('btsync::config') }
    it { should contain_file('/etc/btsync').with({
      :ensure  => :directory,
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0755',
      :purge   => true,
      :recurse => true,
      :force   => true,
    })}

    it { should contain_class('btsync::service') }
    it { should contain_service('btsync').with({
      :ensure => :running,
      :enable => true,
    })}

  end

  context 'when specifying a version' do
    let(:params) { {
      :version => '1.2.3',
    } }

    it { should compile.with_all_deps }

    it { should create_class('btsync')\
      .with_version('1.2.3')\
      .with_enable(true)\
      .with_start(true)\
      .with_instances({}) }

    it { should contain_package('btsync').with({
      :ensure => '1.2.3',
    })}
  end

  context 'when setting enable to false' do
    let(:params) { {
      :enable => false,
    } }

    it { should compile.with_all_deps }

    it { should contain_service('btsync').with({
      :ensure => :running,
      :enable => false,
    })}
  end

  context 'when setting start to false' do
    let(:params) { {
      :start => false,
    } }

    it { should compile.with_all_deps }

    it { should contain_service('btsync').with({
      :ensure => :stopped,
      :enable => true,
    })}
  end

  context 'when specifying an instance' do
    let(:params) { {
      :instances => {
        'btsync' => { }
      }
    } }

    it { should compile.with_all_deps }

    it { should create_class('btsync')\
      .with_version('present')\
      .with_enable(true)\
      .with_start(true)\
      .with_instances({
        'btsync' => { },
      }) }

    it { should contain_btsync__instance('btsync') }
  end

  context 'when specifying multiple instances' do
    let(:params) { {
      :instances  => {
        'btsync1' => { },
        'btsync2' => { },
      }
    } }

    it { should compile.with_all_deps }

    it { should create_class('btsync')\
      .with_version('present')\
      .with_enable(true)\
      .with_start(true)\
      .with_instances({
        'btsync1' => { },
        'btsync2' => { },
      }) }
    it { should contain_btsync__instance('btsync1') }
    it { should contain_btsync__instance('btsync2') }
  end

end
