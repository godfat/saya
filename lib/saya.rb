
require 'saya/api'
require 'rack'

Saya::Root   = File.expand_path("#{__dir__}/..")
Saya::Server = Rack::Builder.app do
  use Rack::ContentLength
  use Rack::ContentType
  use Rack::Session::Pool
  use Rack::Config do |env|
    env['PATH_INFO'] = 'index.html' if env['PATH_INFO'] == '/'
  end

  map '/api' do run Saya::API.new                          end
  map '/'    do run Rack::File.new("#{Saya::Root}/public") end

  env = ENV['RACK_ENV'] || 'production'

  RC::Config.load(RC::Twitter,
    "#{Saya::Root}/config/auth.yaml", env, 'twitter')

  RC::Config.load(RC::Facebook,
    "#{Saya::Root}/config/auth.yaml", env, 'facebook')
end
