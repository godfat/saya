
require 'jellyfish'

module Saya
  class Core
    include Jellyfish

    post %r{\A/?post\Z} do
    end
  end
end
