require 'bundler'
Bundler.require(:rake)
require 'rake/clean'

CLEAN.include('spec/fixtures/', 'doc', 'pkg')
CLOBBER.include('.tmp', '.librarian')

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet_blacksmith/rake_tasks'

# use librarian-puppet to manage fixtures instead of .fixtures.yml
# offers more possibilities like explicit version management, forge
# downloads,...
task :librarian_spec_prep do
  sh "librarian-puppet install --path=spec/fixtures/modules/"
  File.symlink("../../..", "spec/fixtures/modules/btsync")
end
task :spec_prep => :librarian_spec_prep

task :default => [:clean, :spec]
