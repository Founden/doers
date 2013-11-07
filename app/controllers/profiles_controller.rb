# Handles user profiles
class ProfilesController < ApplicationController
  include EasyAuth::Controllers::Authenticated

  # Filter users without `admin?` access on page edits
  before_filter :require_admin, :only => :edit

  # Shows current user profile
  def mine
  end

  # Notifications settings for user projects
  def notifications
    membership = current_account.memberships.find_by(
      :id => params[:membership][:id]) if params[:membership]

    if membership and membership.update_attributes(membership_params.except(:id))
      flash[:success] = _('Notifications updated.')
    end
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

    if pic = user_params[:avatar]
      pic = URI.parse(pic) if pic.to_s.match(Asset::URI_REGEXP)
      @profile.avatar.update_attributes(:attachment => pic) if @profile.avatar
      @profile.create_avatar(:attachment => pic) unless @profile.avatar
    end

    if @profile.update_attributes(user_params.except(:avatar))
      flash[:success] = _('Profile updated.')
    end
    render @profile == current_account ? :mine : :edit
  end

  private

  # Allowed user parameters
  def user_params
    attrs = [:name, :newsletter_allowed, :avatar]
    attrs << :confirmed if current_account.admin?
    params.require(:user).permit(attrs)
  end

  def membership_params
    params.require(:membership).permit(:notify_discussions, :notify_collaborations,
      :notify_boards_topics, :notify_cards_alignments, :id)
  end

  # Check if `current_account` has `admin?`
  def require_admin
    redirect_to mine_profiles_path unless current_account.admin?
  end
end
