require 'spec_helper'

describe 'btsync::service' do

  context 'when not declaring Class[btsync]' do
    it { expect { should create_class('btsync::service')}.to raise_error(Puppet::Error, /You should not declare this class explicitely, it should be done by Class\[btsync\]./) }
  end

  context 'when a parameter is passed' do
    let(:params) { {
      :foo => 'bar',
    } }

    it { expect { should create_class('btsync::service')}.to raise_error(Puppet::Error, /Invalid parameter foo/) }
  end

end

