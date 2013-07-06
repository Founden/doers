# API (v1) [Board] controller class
class Api::V1::BoardsController < Api::V1::ApplicationController
  # Shows available board
  def index
    board = current_account.all_boards.where(:id => params[:ids])
    render :json => board
  end

  # Shows available board
  def show
    board = current_account.all_boards.find(params[:id])
    render :json => board
  end

  # Handles board creation
  def create
    # TODO: handle project relationship
    board = current_account.boards.build(new_board_params)
    if board.save
      render :json => board
    else
      render :json => { :errors => board.errors.messages }
    end
  end

  # Handles board changes
  def update
    board = current_account.boards.find(params[:id])
    board.update_attributes(board_params)
    render :json => board
  end

  # Handles board deletion
  def destroy
    board = current_account.boards.find_by(:id => params[:id])
    if board and board.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new board
    def new_board_params
      # TODO: Authorize if only parent board is public and project is owned
      params.require(:board).
        permit(:title, :description, :project_id, :parent_board_id)
    end

    # Strong parameters for updating a board
    def board_params
      params.require(:board).permit(:title, :description)
    end
end
