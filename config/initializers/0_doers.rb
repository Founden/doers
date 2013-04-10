# Application namespace
module Doers
  # Our settings management class
  class Config < Settingslogic
    source Rails.root.join('config', 'doers.yml').to_s
    namespace Rails.env
  end
end
