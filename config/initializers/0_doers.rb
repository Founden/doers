# Application namespace
module Doers
  # Our settings management class
  class Config < ReadWriteSettings
    source Rails.root.join('config', 'doers.yml').to_s
    namespace Rails.env
  end
end
