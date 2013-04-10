# Handles sessions for our app
class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  # Show available authentication options
  def index
  end

  private

  # Returns location to redirect after signing in
  def after_successful_sign_in_url_default
    profile_path(current_user)
  end
end
