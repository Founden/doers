# API (v1) memberships controller class
class Api::V1::MembershipsController < Api::V1::ApplicationController

  # Lists memberships
  def index
    memberships = current_account.memberships.where(:id => params[:ids])
    render :json => memberships
  end

  # Shows a membership
  def show
    user = current_account.memberships.find(params[:id])
    render :json => (user || current_account)
  end

  # Handles membership deletion
  def destroy
    membership = current_account.memberships.find_by(:id => params[:id])

    if membership and membership.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end
end
