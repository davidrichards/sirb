# require 'rubygems'
# require 'rake'
# require 'echoe'
# require 'lib/version'
# 
# Echoe.new('sirb', Sirb::VERSION) do |p|
#   p.description              = "Generate a unique token with Active Record." 
#   p.url                      = "http://github.com/davidrichards/sirb" 
#   p.author                   = "David Richards" 
#   p.email                    = "drichards@showcase60.com" 
#   p.ignore_pattern           = ["tmp/*", "script/*"]
#   p.development_dependencies = []
# end
# 
# Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
# 
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "sirb"
    s.summary = "Descriptive statistics + IRB + any other useful numerical library you may have around"
    s.email = "davidlamontrichards@gmail.com"
    s.homepage = "http://github.com/davidrichards/sirb"
    s.description = "A series of useful tools that a console should probably have, if your goal is to crunch a few numbers. It includes all the packages that I use, if you have them.  Also incorporates some functional style programming and stored procedures to make your console experience even more delightful."
    s.authors = ["David Richards"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'sirb'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :test
