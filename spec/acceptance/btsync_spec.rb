require 'spec_helper_acceptance'

describe 'btsync class' do

  describe 'without parameter' do

    it 'should install btsync' do
      pp = <<-EOS
        class { 'btsync::repo': } ->
        class { 'btsync': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

  end

end
