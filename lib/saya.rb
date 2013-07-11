
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
end
