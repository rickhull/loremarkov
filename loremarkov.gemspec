Gem::Specification.new do |s|
  s.name        = 'loremarkov'
  s.summary     = "Lorem ipsum and more: create your own filler text"
  s.description = "Text goes in, markov gibberish comes out"
  s.authors     = ["Rick Hull"]
  s.homepage    = 'https://github.com/rickhull/loremarkov'
  s.license     = 'LGPL-3.0'

  s.required_ruby_version = "> 2"

  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp

  s.files  = %w[loremarkov.gemspec VERSION Rakefile README.md]
  s.files += Dir['lib/**/*.rb']
  s.files += Dir['text/**/*.rb']
  s.files += Dir['test/**/*']
  s.files += Dir['bin/**/*.rb']
  s.executables = ['destroy']
end
