Gem::Specification.new do |s|
  s.name        = 'loremarkov'
  s.summary     = "Lorem ipsum and more: create your own filler text"
  s.description = "Text goes in, markov gibberish comes out"
  s.authors     = ["Rick Hull"]
  s.homepage    = 'https://github.com/rickhull/loremarkov'
  s.license     = 'GPL'
  s.files       = [
    'loremarkov.gemspec',
    'VERSION',
    'Rakefile',
    'README.md',
    'lib/loremarkov.rb',
    'bin/destroy',
  ]
  s.executables = ['destroy']
  s.add_development_dependency "buildar", "~> 2"
  s.add_development_dependency "minitest", "~> 5"
  s.required_ruby_version = "~> 2"

  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp
end
