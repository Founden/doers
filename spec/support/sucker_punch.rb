require 'sucker_punch/testing'

RSpec.configure do |config|
  config.after do
    SuckerPunch.reset!
  end
end
