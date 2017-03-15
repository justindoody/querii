$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'querii'
  s.version     = '1.0.0'
  s.authors     = %w[Justin Doody]
  s.email       = %w[justin@20dots.com]
  s.homepage    = 'https://github.com/justindoody/querii'
  s.summary     = 'AR Query objects patterns'
  s.description = 'Easily extract complicated query objects into simple query object services.'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*', 'README.md']

  s.add_dependency 'activesupport'

  s.add_development_dependency 'bundler', '~> 1.14'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'binding_of_caller'
end
