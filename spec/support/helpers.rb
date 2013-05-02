module Doers::RSpecHelpers
  def sign_in_with_twitter
    visit oauth_callback_path(
      :provider => :twitter,
      :oauth_token => 'DUMMY_TOKEN',
      :oauth_token_secret => 'DUMMY_SECRET'
    )
  end
end

RSpec.configure do |config|
  config.include Doers::RSpecHelpers
end
