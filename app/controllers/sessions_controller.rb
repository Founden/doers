# Handles sessions for our app
class SessionsController < ApplicationController
  include EasyAuth::Controllers::Sessions

  # Skip authentication check to make sure we can log out
  skip_before_filter :require_confirmation, :only => [:destroy]

  # Show available authentication options
  def index
  end

  private
  # Returns location to redirect after signing in failure
  def after_failed_sign_in
    flash[:error] = _('Something went wrong. Please try again.')
    redirect_to root_path
  end

  # Returns location to redirect after signing in
  def after_successful_sign_in_url
    profile_path(current_account)
  end
end
