
require 'saya'

ENV['RACK_ENV']  ||= 'production'
ENV['SAYA_AUTH'] ||= "#{Saya::Root}/config/auth.yaml"

# load rest-core config
%w[Twitter Facebook].each do |name|
  RC::Config.load(RC.const_get(name),
    ENV['SAYA_AUTH'], ENV['RACK_ENV'], name.downcase)
end

