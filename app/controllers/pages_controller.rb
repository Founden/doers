# Handles application pages
class PagesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  skip_before_filter :require_confirmation, :only => [:waiting]

  # Shows main dashboard
  def dashboard
  end

  # Show this page for unconfirmed users
  def waiting
    if params[:user] and current_account.update_attributes(user_params)
      flash[:success] = _('Your application was updated. Thank you.')
    end
  end

  private

  # Allowed params for [User] objects
  def user_params
    params.require(:user).permit(:interest, :newsletter_allowed)
  end

end
