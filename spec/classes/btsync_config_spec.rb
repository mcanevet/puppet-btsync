require 'spec_helper'

describe 'btsync::config' do

  context 'when not declaring Class[btsync]' do
    it { expect { is_expected.to compile }.to raise_error(/You should not declare this class explicitely, it should be done by Class\[btsync\]./) }
  end

  context 'when a parameter is passed' do
    let(:params) { {
      :foo => 'bar',
    } }

    it { expect { is_expected.to compile }.to raise_error(/Invalid parameter/) }
  end

end

