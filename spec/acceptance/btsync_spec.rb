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

  describe 'with sample configuration' do

    it 'should install btsync' do
      pp = <<-EOS
        class { 'btsync::repo': } ->
        class { 'btsync':
          instances => {
            vagrant => {
              device_name       => 'My Sync Device',
              listening_port    => 0,
              storage_path      => '/home/vagrant/.sync',
              check_for_updates => false,
              use_upnp          => true,
              download_limit    => 0,
              upload_limit      => 0,
              webui             => {
                listen   => '0.0.0.0:8888',
                login    => 'admin',
                password => 'password',
              },
              shared_folders    => {
                'MY_SECRET_1' => {
                  dir              => '/home/vagrant/bittorrent/sync_test',
                  use_relay_server => true,
                  use_tracker      => true,
                  use_dht          => true,
                  search_lan       => true,
                  use_sync_trash   => true,
                  known_hosts      => [ '192.168.1.2:44444', ],
                },
              },
            }
          }
        }
      EOS


      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

  end

end
