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
    commentable_type = comment_params[:commentable_type]
    comment = current_account.comments.build
    errors = nil

    if (commentable_type == 'Card' or commentable_type.blank?)
      comment.attributes = comment_params
      commentable = (comment.commentable || comment.board || comment.project)
      current_account.can?(:read, commentable)
    else
      errors = [_('Commentable not allowed.')]
    end

    if !errors and comment.save
      render :json => comment
    else
      render :json => { :errors => errors || comment.errors.messages }
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
        :commentable_id, :commentable_type, :parent_comment_id)
    end
end
