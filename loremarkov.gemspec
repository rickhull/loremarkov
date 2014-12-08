Gem::Specification.new do |s|
  s.name        = 'loremarkov'
  s.summary     = "Conway's Game of Life"
  s.description = "Deathmatch"
  s.authors     = ["Rick Hull"]
  s.homepage    = 'https://github.com/rickhull/loremarkov'
  s.license     = 'GPL'
  s.files       = [
    'loremarkov.gemspec',
    'VERSION',
    'Rakefile',
    'README.md',
    'lib/loremarkov.rb',
    'bin/loremarkov',
  ]
  s.executables = ['loremarkov']
  s.add_development_dependency "buildar", "~> 2"
  s.add_development_dependency "minitest", "~> 5"
  s.required_ruby_version = "~> 2"

  s.version     = File.read(File.join(__dir__, 'VERSION')).chomp
end
