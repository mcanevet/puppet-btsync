require 'spec_helper'

describe 'btsync::install' do

  context 'when not declaring Class[btsync]' do
    it { expect { should create_class('btsync::install')}.to raise_error(Puppet::Error, /You should not declare this class explicitely, it should be done by Class\[btsync\]./) }
  end

  context 'when a parameter is passed' do
    let(:params) { {
      :foo => 'bar',
    } }

    it { expect { should create_class('btsync::install')}.to raise_error(Puppet::Error, /Invalid parameter foo/) }
  end

  context 'when using default parameters' do
    let :pre_condition do
      "class {'btsync': }"
    end

    it { should create_class('btsync::install') }
    it { should contain_package('btsync').with({
      :ensure => :present,
    })}
  end

  context 'when specifying a version' do
    let :pre_condition do
      "class {'btsync': version => '1.2.3',}"
    end

    it { should create_class('btsync::install') }
    it { should contain_package('btsync').with({
      :ensure => '1.2.3'
    })}
  end

end
