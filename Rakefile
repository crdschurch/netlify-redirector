$LOAD_PATH.unshift File.join(FileUtils.pwd, 'lib')
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'rake'
require 'rspec/core/rake_task'
require 'netlify-redirector'

Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake" ].each{ |rake_file| load rake_file }

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

task :default => :spec

