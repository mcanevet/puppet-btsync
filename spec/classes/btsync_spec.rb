require 'spec_helper'

describe 'btsync' do

  context 'default parameters' do
    let(:params) { { } }

    it { should create_class('btsync')\
      .with_version('present')\
      .with_enable(true)\
      .with_start(true)\
      .with_instances({}) }  
    it { should contain_class('btsync::install') }
    it { should contain_class('btsync::config') }
    it { should contain_class('btsync::service') }
  end

  context 'with an instance' do
    let(:params) { {
      :instances => {
        'btsync' => { }
      }
    } }
    it { should contain_btsync__instance('btsync') }
  end

  context 'with multiple instances' do
    let(:params) { {
      :instances  => {
        'btsync1' => { },
	      'btsync2' => { },
      }
    } }
    it { should contain_btsync__instance('btsync1') }
    it { should contain_btsync__instance('btsync2') }
  end

end
