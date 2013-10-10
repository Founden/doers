# API (v1) comments controller class
class Api::V1::CommentsController < Api::V1::ApplicationController
  # Lists available comments
  def index
    comments = Comment.where(:id => params[:ids])
    current_account.can?(:read, comments)
    render :json => comments
  end

  # Shows a comment
  def show
    comment = Comment.find(params[:id])
    current_account.can?(:read, comment)
    render :json => comment
  end

  # Handles comment creation
  def create
    comment = current_account.comments.build(comment_params)
    current_account.can?(:write, comment.project) if comment.project
    current_account.can?(:write, comment.board) if comment.board
    current_account.can?(:read, comment.topic)

    if comment.save
      render :json => comment
    else
      render :json => { :errors => comment.errors.messages }
    end
  end

  # Handles comment deletion
  def destroy
    comment = Comment.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, comment, :raise_error => false)

    if comment and can_destroy and comment.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for comment object
    def comment_params
      params.require(:comment).permit(:content, :project_id, :board_id,
        :topic_id, :card_id, :parent_comment_id)
    end
end
