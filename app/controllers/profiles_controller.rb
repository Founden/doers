# Handles user profiles
class ProfilesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  # Shows current user profile
  def mine
  end

  # Shows user profile
  def show
    @profile = User.find(params[:id])
  end

  # Updates user profile
  def update
    if current_user.update_attributes(user_params)
      flash[:success] = _('Profile updated.')
    else
      flash[:alert] = _('Profile could not be updated. Try again.')
    end
    render :show
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
