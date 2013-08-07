require 'spec_helper'

describe 'btsync' do

  context "default parameters" do
    it { should contain_class('btsync::config') }
    it { should contain_class('btsync::install') }
    it { should contain_class('btsync::service') }
  end

  context "with webui" do
    let(:params) {{
      :instances => {
        :btsync => {
          :storage_path => '/home/btsync/.sync',
          :webui        => {
            :listen   => '0.0.0.0:8888',
            :login    => 'btsync',
            :password => 'password',
          }
        }
      }  
    }}

    it { should contain_class('btsync::config') }
    it { should contain_class('btsync::install') }
    it { should contain_class('btsync::service') }
    it { should contain_btsync__instance('btsync') }
  end
end
