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

  # Callback to be called after someone signs in
  def after_successful_sign_in
    invite = current_account.claim_invitation
    if invite
      invitable = invite.invitable
      invitable_name = invitable.class.name.downcase
      anchor = '/%s/%d' % [invitable_name.pluralize, invitable.id]

      flash[:success] = _('%s invited you to collaborate on %s %s.') % [
        invite.user.nicename, invitable.title, invitable_name ]

      redirect_to root_path(:anchor => anchor)
    else
      super
    end
  end

  # Returns location to redirect after signing in
  def after_successful_sign_in_url
    root_path
  end
end
