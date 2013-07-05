module Doers::RSpecHelpers
  def sign_in_with_angel_list
    visit oauth2_callback_path(
      :provider => :angel_list,
      :code => 'DUMMY_CODE'
    )
    # TODO: Remove this once we do not need confirmations anymore
    User.last.update_attribute(:confirmed, true)
  end

  # Parses a JSON into an OpenStruct data set
  # Remember, nested groups are not parsed, so [Hash] access is still needed
  #
  # @param [String] string, the JSON content
  # @param [Symbol] root, the JSON root to use
  def json_to_ostruct(string, root=nil)
    json = ActiveSupport::JSON.decode(string)
    ostruct = root ? OpenStruct.new(json[root.to_s]) : OpenStruct.new(json)
    ostruct.keys = root ? json[root.to_s].keys : json.keys
    ostruct
  end
end

RSpec.configure do |config|
  config.include Doers::RSpecHelpers
end
