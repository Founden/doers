# API (v1) endorses controller class
class Api::V1::EndorsesController < Api::V1::ApplicationController
  # Lists available endorses
  def index
    endorses = Endorse.where(:id => params[:ids])
    current_account.can?(:read, endorses)
    render :json => endorses
  end

  # Shows an endorse
  def show
    endorse = Endorse.find_by(:id => params[:id])
    current_account.can?(:read, endorse)
    render :json => endorse
  end

  # Creates an endorse
  def create
    endorse = current_account.endorses.build(create_params)
    current_account.can?(:write, endorse.board)

    if endorse.save
      render :json => endorse
    else
      render :json => {:errors => endorse.errors.messages}, :status => 400
    end
  end

  # Handles endorse deletion
  def destroy
    endorse = Endorse.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, endorse, :raise_error => false)

    if endorse and can_destroy and endorse.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new endorse
    def create_params
      params.require(:endorse).
        permit(:project_id, :board_id, :topic_id, :card_id)
    end
end
