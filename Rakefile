require 'rake'
require 'rspec/core/rake_task'

desc "Run all RSpec code examples"
def spec_opts
  begin
    File.read("spec/spec.opts").chomp || ""
  rescue
    ""
  end
end

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = spec_opts
end

SPEC_SUITES = (Dir.entries('spec') - ['.', '..','fixtures']).select {|e| File.directory? "spec/#{e}" }
namespace :rspec do
  SPEC_SUITES.each do |suite|
    desc "Run #{suite} RSpec code examples"
    RSpec::Core::RakeTask.new(suite) do |t|
      t.pattern = "spec/#{suite}/**/*_spec.rb"
      t.rspec_opts = spec_opts
    end
  end
end
task :default => :rspec