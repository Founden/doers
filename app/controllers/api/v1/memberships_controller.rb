# API (v1) memberships controller class
class Api::V1::MembershipsController < Api::V1::ApplicationController

  # Lists memberships
  def index
    memberships = Membership.where(:id => params[:ids])
    current_account.can?(:read, memberships)
    render :json => memberships
  end

  # Shows a membership
  def show
    membership = Membership.find_by!(:id => params[:id])
    current_account.can?(:read, membership)
    render :json => membership
  end

  # Handles membership deletion
  def destroy
    membership = Membership.find_by(:id => params[:id])
    can_destroy = current_account.can?(
      :write, membership, :raise_error => false)

    if membership and can_destroy and membership.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end
end
