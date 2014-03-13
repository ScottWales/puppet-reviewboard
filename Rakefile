require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ['pkg/**/*.pp','vendor/**/*.pp']

task :default => :spec
