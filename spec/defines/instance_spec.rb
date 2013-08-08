require 'spec_helper'

describe 'btsync::instance', :type => :define do

  context 'without parameters' do
    let(:title) { 'btsync' }

    it { should contain_concat_build('btsync_btsync') }
    it { should contain_file('/etc/btsync/btsync.conf').with(
      :owner => 'btsync',
      :group => nil,
      :mode  => '0400'
    ) }
    it { should contain_concat_fragment('btsync_btsync+01') }
    it { should contain_concat_fragment('btsync_btsync+02')\
      .with_content('{') }
    it { should contain_concat_build('btsync_btsync_json').with(
      :parent_build   => 'btsync_btsync',
      :target         => '/var/lib/puppet/concat/fragments/btsync_btsync/03',
      :file_delimiter => ',',
      :append_newline => :false
    ) }
    it { should contain_concat_fragment('btsync_btsync_json+01') }
    it { should contain_concat_fragment('btsync_btsync_json+02') }
    it { should contain_concat_fragment('btsync_btsync+99')\
      .with_content('}') }
  end

end
