
require 'jellyfish'
require 'rest-more'
require 'rack'

module Saya
  class API
    include Jellyfish

    twitter = %r{\A/?auth/twitter\Z}
    get twitter do
      rc_twitter{ |t|
        t.authorize!('oauth_verifier' => request.params['oauth_verifier']) }
      name = "@#{rc_twitter.me['screen_name']}"
      set_cookie('twitter_name', name)
      # we need 200 redirect because in 302 we cannot really set cookie!
      <<-HTML
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="refresh" content="0;URL='#{request.base_url}'">
    <script>window.location = #{request.base_url.inspect}</script>
  </head>
  <body>
  </body>
</html>
HTML
    end

    post twitter do
      rc_twitter{ |t|
        t.authorize_url!('oauth_callback' => request.url) }
    end

    get  %r{\A/?auth/facebook\Z} do
    end

    post %r{\A/?post\Z} do
    end

    handle RC::Twitter::Error do
      set_cookie('twitter_name', nil)
      session.delete('rc.twitter')
      rc_twitter.data = nil
      status, headers, body = call(env)
      self.status  status
      self.headers headers
      self.body    body
    end

    controller_include Module.new{
      def rc_twitter
        @rc_twitter ||= RC::Twitter.new(session['rc.twitter'] || {})
        if block_given?
          ret = yield @rc_twitter
          session['rc.twitter'] = {'data' => rc_twitter.data}
          ret
        else
          @rc_twitter
        end
      end

      def set_cookie key, value
        headers_merge({})
        if value
          Rack::Utils.set_cookie_header!(headers, key, :value => value,
                                                       :path  => '/')
        else
          Rack::Utils.delete_cookie_header!(headers, key)
        end
      end

      def session
        env['rack.session']
      end
    }
  end
end
