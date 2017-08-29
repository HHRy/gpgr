require "bundler/gem_tasks"
require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |test|
  # test.ruby_opts  << "-w"  # .should == true triggers a lot of warnings
  test.libs       << "testrb"
  test.test_files =  Dir[ "test/test_*.rb" ]
  test.verbose    =  true
end
