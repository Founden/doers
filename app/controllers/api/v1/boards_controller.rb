# API (v1) [Board] controller class
class Api::V1::BoardsController < Api::V1::ApplicationController
  # Shows available boards
  def index
    if params[:status]
      boards = current_account.accessible_boards.where(
        :status => params[:status])
    else
      boards = current_account.accessible_boards.where(:id => params[:ids])
    end
    render :json => boards
  end

  # Shows available board
  def show
    board = current_account.accessible_boards.find(params[:id])
    render :json => board
  end

  # Handles board creation
  def create
    if current_account.admin?
      new_params = create_params.except(:user_id, :project_id, :parent_board_id).
        merge(:status => 'public', :author_id => current_account.id)
      board = Board.create(new_params)
    else
      # Lets raise 404 if parent board or project is not available
      parent_board = current_account.accessible_boards.find_by!(
        :id => create_params[:parent_board_id])
      project = current_account.projects.find_by!(
        :id => create_params[:project_id])
      board = parent_board.branch_for(current_account, project, create_params)
    end

    if board.errors.empty?
      render :json => board
    else
      errors = board.errors.messages
      render :json => { :errors => errors }, :status => 400
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
    def create_params
      params.require(:board).
        permit(:title, :description, :project_id, :parent_board_id)
    end

    # Strong parameters for updating a board
    def board_params
      params.require(:board).permit(:title, :description)
    end
end
