
require 'jellyfish'
require 'rest-more'
require 'rack'

module Saya
  class API
    include Jellyfish

    controller_include Module.new{
      def set_cookie key, value
        if value
          Rack::Utils.set_cookie_header!(headers, key, value)
        else
          Rack::Utils.delete_cookie_header!(headers, key)
        end
      end

      def rc_twitter
        @rc_twitter ||= RC::Twitter.new(session['rc.twitter'] || {})
        if block_given?
          ret = yield @rc_twitter
          session['rc.twitter'] = {:data => rc_twitter.data}
          ret
        else
          @rc_twitter
        end
      end

      def session
        env['rack.session']
      end
    }

    get  %r{\A/?auth/twitter\Z} do
      if rc_twitter.authorized?
        rc_twitter.me.inspect
      elsif verifier = request.params['oauth_verifier']
        rc_twitter{ |t| t.authorize!(:oauth_verifier => verifier) }
        rc_twitter.me.inspect
      else
        found rc_twitter{ |t|
                t.authorize_url!(:oauth_callback => request.url) }
      end
    end

    get  %r{\A/?auth/facebook\Z} do
    end

    post %r{\A/?post\Z} do
    end
  end
end
