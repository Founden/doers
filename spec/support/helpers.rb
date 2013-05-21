module Doers::RSpecHelpers
  def sign_in_with_angel_list
    visit oauth2_callback_path(
      :provider => :angel_list,
      :code => 'DUMMY_CODE'
    )
  end
end

RSpec.configure do |config|
  config.include Doers::RSpecHelpers
end
