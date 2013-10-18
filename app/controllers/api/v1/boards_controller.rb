# API (v1) [Board] controller class
class Api::V1::BoardsController < Api::V1::ApplicationController
  # Shows available boards
  def index
    boards = Board.where(:id => params[:ids])
    current_account.can?(:read, boards)
    render :json => boards
  end

  # Shows available board
  def show
    board = Board.find_by!(:id => params[:id])
    current_account.can?(:read, board)
    render :json => board
  end

  # Handles board creation
  def create
    # Lets raise 404 if project is not available
    project = Project.find_by!(:id => create_params[:project_id])
    current_account.can?(:read, project)
    board = project.boards.create(create_params.merge(:user => current_account))

    if board.errors.empty?
      render :json => board
    else
      errors = board.errors.messages
      render :json => { :errors => errors }, :status => 400
    end
  end

  # Handles board changes
  def update
    board = Board.find_by!(:id => params[:id])
    current_account.can?(:write, board)
    board.update_attributes(board_params)
    render :json => board
  end

  # Handles board deletion
  def destroy
    board = Board.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, board, :raise_error => false)

    if board and can_destroy and board.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new board
    def create_params
      params.require(:board).permit(:title, :description, :project_id)
    end

    # Strong parameters for updating a board
    def board_params
      params.require(:board).permit(:title, :description)
    end
end
