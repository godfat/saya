
require 'saya/core'
require 'rack'

Saya::Root   = File.expand_path("#{__dir__}/..")
Saya::Server = Rack::Builder.new do
  use Rack::ContentLength
  use Rack::ContentType

  map '/api' do
    run Saya::Core.new
  end

  map '/' do
    use Rack::Config do |env|
      env['PATH_INFO'] = 'index.html' if env['PATH_INFO'] == '/'
    end
    run Rack::File.new("#{Saya::Root}/public")
  end
end
