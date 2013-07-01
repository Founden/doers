# Handles user profiles
class ProfilesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  # Filter users without `admin?` access on page edits
  before_filter :require_admin, :only => :edit

  # Shows current user profile
  def mine
  end

  # Shows user profile
  def show
    @profile = User.find(params[:id])
  end

  # Edit page for user profile
  def edit
    @profile = User.find(params[:id])
  end

  # Updates user profile
  def update
    @profile = current_account
    @profile = User.find(params[:id]) if current_account.admin?

    if @profile.update_attributes(user_params)
      flash[:success] = _('Profile updated.')
    else
      flash[:alert] = _('Profile could not be updated. Try again.')
    end
    render :show
  end

  private

  # Allowed user parameters
  def user_params
    if current_account.admin?
      params.require(:user).permit(:name, :newsletter_allowed, :confirmed)
    else
      params.require(:user).permit(:name, :newsletter_allowed)
    end
  end

  # Check if `current_account` has `admin?`
  def require_admin
    redirect_to mine_profiles_path unless current_account.admin?
  end
end
