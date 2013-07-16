
require 'jellyfish'
require 'rest-more'
require 'rack'

module Saya
  class API
    include Jellyfish

    twitter = %r{\A/?auth/twitter\Z}
    post twitter do
      rc_twitter{ |t|
        t.authorize_url!('oauth_callback' => request.url) }
    end
    get twitter do
      rc_twitter{ |t|
        t.authorize!('oauth_verifier' => request.params['oauth_verifier']) }
      name = "@#{rc_twitter.me['screen_name']}"
      set_cookie('twitter_name', name)
      html_redirect
    end

    facebook = %r{\A/?auth/facebook\Z}
    post facebook do
      rc_facebook.authorize_url('redirect_uri' => request.url,
                                'scope' => 'publish_stream')
    end
    get facebook do
      rc_facebook{ |f| f.authorize!('redirect_uri' => request.url,
                                    'code' => request.params['code']) }
      name = "#{rc_facebook.me['name']}"
      set_cookie('facebook_name', name)
      html_redirect
    end

    post %r{\A/?post\Z} do
      %w[twitter facebook].select{ |t| request.params[t] }.map do |target|
        send("post_#{target}", request.params['post'])
      end.each{ |future| handle_future(future) }
      found request.base_url
    end

    handle RC::Twitter::Error do |e|
      set_cookie('twitter_name', nil)
      session.delete('rc.twitter')
      rc_twitter.data = nil
      status 401
      "Authorization failed: #{e.message}"
    end

    handle RC::Facebook::Error do |e|
      set_cookie('facebook_name', nil)
      session.delete('rc.facebook')
      rc_facebook.data = nil
      status 401
      "Authorization failed: #{e.message}"
    end

    controller_include Module.new{
      def post_twitter post
        rc_twitter.tweet(post)
      end

      def post_facebook post
        rc_facebook.post('me/feed', :message => post)
      end

      def handle_future future
        Thread.new{
          begin
            future.tap{}
          rescue RC::Error => e
            halt(e)
          end
        }
      end

      def rc_twitter
        @rc_twitter ||= RC::Twitter.new(rc_data('twitter'))
        if block_given?
          ret = yield @rc_twitter
          session['rc.twitter'] = {'data' => rc_twitter.data}
          ret
        else
          @rc_twitter
        end
      end

      def rc_facebook
        @rc_facebook ||= RC::Facebook.new(rc_data('facebook'))
        if block_given?
          ret = yield @rc_facebook
          session['rc.facebook'] = {'data' => rc_facebook.data}
          ret
        else
          @rc_facebook
        end
      end

      def log_method
        env['rack.errors'].method(:puts)
      end

      def rc_data target
        (session["rc.#{target}"] || {}).merge(:log_method => log_method)
      end

      # we need 200 redirect because in 302 we cannot really set cookie!
      def html_redirect
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

      def set_cookie key, value
        headers_merge({})
        if value
          Rack::Utils.set_cookie_header!(headers, key, :value => value,
                                                       :path  => '/')
          headers['Set-Cookie'].gsub!('+', '%20')
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
