# API (v1) [Board] controller class
class Api::V1::BoardsController < Api::V1::ApplicationController
  
  def index
    boards = current_account.boards.where(:id => params[:ids])
    render :json => boards
  end

  # Shows available board
  def show
    board = Board.find(params[:id])
    render :json => board
  end

  # Handles board creation
  def create
    # TODO: handle project relationship
    board = current_account.board.build(board_params)
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

    # Strong parameters for board object
    def board_params
      params.require(:board).permit(:title, :description, :status)
    end
end
