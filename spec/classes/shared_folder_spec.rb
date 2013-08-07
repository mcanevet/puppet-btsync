require 'spec_helper'

describe 'btsync::shared_folder' do

  context "default parameters" do
    it { should contain_btsync__known_host('') }
  end

end
