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

task default: %w[test rocco] # bench]

require 'rake/testtask'
desc "Run tests"
Rake::TestTask.new do |t|
  t.name = "test"
  t.pattern = "test/test_*.rb"
  # t.warning = true
end

desc "Run benchmarks"
Rake::TestTask.new do |t|
  t.name = "bench"
  t.pattern = "test/bench_*.rb"
  # t.warning = true
end

desc "Run rocco - generate literate programming html"
task :rocco do
  Dir.chdir File.join(__dir__, 'lib') do
    `rocco *.rb -o ../rocco/`
  end
end
