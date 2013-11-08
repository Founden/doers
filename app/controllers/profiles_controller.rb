# Handles user profiles
class ProfilesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  # Notifications settings for user projects
  def notifications
    membership = current_account.memberships.find_by(
      :id => params[:membership][:id]) if params[:membership]

    if membership and membership.update_attributes(membership_params.except(:id))
      flash[:success] = _('Notifications updated.')
    end
  end

  # Shows user profile
  def mine
    @profile = current_account
  end

  # Updates user profile
  def update
    @profile = current_account

    if pic = user_params[:avatar]
      pic = URI.parse(pic) if pic.to_s.match(Asset::URI_REGEXP)
      @profile.avatar.update_attributes(:attachment => pic) if @profile.avatar
      @profile.create_avatar(:attachment => pic) unless @profile.avatar
    end

    if @profile.update_attributes(user_params.except(:avatar))
      flash[:success] = _('Profile updated.')
    end
    redirect_to mine_profiles_path
  end

  private

  # Allowed user parameters
  def user_params
    params.require(:user).permit(:name, :newsletter_allowed, :avatar)
  end

  def membership_params
    params.require(:membership).permit(
      :notify_discussions, :notify_collaborations,
      :notify_boards_topics, :notify_cards_alignments, :id)
  end
end
