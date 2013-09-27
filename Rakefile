
begin
  require "#{dir = File.dirname(__FILE__)}/task/gemgem"
rescue LoadError
  sh 'git submodule update --init'
  exec Gem.ruby, '-S', $PROGRAM_NAME, *ARGV
end

Gemgem.init(dir) do |s|
  require 'saya/version'
  s.name    = 'saya'
  s.version = Saya::VERSION
  %w[rack jellyfish rest-more].each{ |g| s.add_dependency(g) }
  %w[bacon rack-handlers].each{ |g| s.add_development_dependency(g) }
end
