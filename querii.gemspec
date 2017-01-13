$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'querii'
  s.version     = '0.0.1'
  s.authors     = ['Justin Doody']
  s.email       = ['justin@20dots.com']
  s.homepage    = 'https://github.com/justindoody/querii'
  s.summary     = ''
  s.description = ''
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']

  s.add_development_dependency 'sqlite3'
end
