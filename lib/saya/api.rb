
require 'jellyfish'

module Saya
  class API
    include Jellyfish

    post %r{\A/?post\Z} do
    end
  end
end
