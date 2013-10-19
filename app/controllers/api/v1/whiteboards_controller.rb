# API (v1) [Whiteboard] controller class
class Api::V1::WhiteboardsController < Api::V1::ApplicationController
  # Shows available whiteboards
  def index
    whiteboards = Whiteboard.where(:id => params[:ids])
    current_account.can?(:read, whiteboards)
    render :json => whiteboards
  end

  # Shows available whiteboard
  def show
    whiteboard = Whiteboard.find_by!(:id => params[:id])
    current_account.can?(:read, whiteboard)
    render :json => whiteboard
  end

  # Handles whiteboard creation
  def create
    if board = Board.find_by(:id => create_params[:board_id])
      whiteboard = board.create_whiteboard(create_params.except(:board_id))
    else
      whiteboard = Whiteboard.create(create_params.except(:board_id))
    end

    if whiteboard.errors.empty?
      render :json => whiteboard
    else
      errors = whiteboard.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Handles whiteboard changes
  def update
    whiteboard = Whiteboard.find_by!(:id => params[:id])
    current_account.can?(:write, whiteboard)
    whiteboard.update_attributes(whiteboard_params)
    render :json => whiteboard
  end

  def destroy
    whiteboard = Whiteboard.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, whiteboard,:raise_error => false)

    if whiteboard and can_destroy and whiteboard.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new whiteboard
    def create_params
      params.require(:whiteboard).permit(:title, :description, :board_id)
    end

    # Strong parameters for updating a board
    def update_params
      params.require(:whiteboard).permit(:title, :description)
    end
end
