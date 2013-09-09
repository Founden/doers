# API (v1) invitations controller class
class Api::V1::InvitationsController < Api::V1::ApplicationController
  # Lists available invitations
  def index
    invitations = current_account.invitations.where(:id => params[:ids])
    render :json => invitations
  end

  # Shows an invitation
  def show
    invitation = current_account.invitations.find(params[:id])
    render :json => invitation
  end

  # Handles invitation creation
  def create
    invitation = current_account.invitations.build(invitation_params)
    user = User.find_by(:email => invitation_params[:email])

    if user
      if invitable = invitation.invitable
        invitation.membership = invitable.memberships.create(
          :creator => current_account, :user => user)
        render :json => invitation
      else
        render :json => { :errors => [_('Email is registered.')] }
      end
    else
      if invitation.save
        render :json => invitation
      else
        render :json => { :errors => invitation.errors.messages }
      end
    end
  end

  # Handles invitation deletion
  def destroy
    invitation = current_account.invitations.find_by(:id => params[:id])

    if invitation and invitation.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for invitation object
    def invitation_params
      params.require(:invitation).permit(:email, :invitable_id, :invitable_type)
    end
end
