require 'rake/testtask'
require 'fileutils'

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

require 'boot'

Rake::TestTask.new do |t|
 t.libs << 'app' << 'test'
 t.test_files = FileList['test/*_test.rb']
 t.verbose = true
end

desc "Start the server"
task :start do
  Kernel.exec "bundle exec foreman start"
end

desc Rake::Task['test'].comment
task :default => :test
