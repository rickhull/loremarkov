require 'rake/testtask'

Rake::TestTask.new :test do |t|
  t.pattern = "test/test_*.rb"
  t.warning = true
end

task default: :test

#
# DOCUMENTATION
#

begin
  require 'rocco/tasks'
  Rocco.make 'rocco/'
rescue LoadError
  warn "rocco/tasks unavailable"
end

#
# GEM BUILD / PUBLISH
#

begin
  require 'buildar'

  Buildar.new do |b|
    b.gemspec_file = 'loremarkov.gemspec'
    b.version_file = 'VERSION'
    b.use_git = true
  end
rescue LoadError
  # Buildar not installed; ok
end
