# API (v1) [Topic] controller class
class Api::V1::TopicsController < Api::V1::ApplicationController
  # Shows available topics
  def index
    topics = Topic.where(:id => params[:ids])
    current_account.can?(:read, topics)
    render :json => topics
  end

  # Shows a topic
  def show
    topic = Topic.find_by!(:id => params[:id])
    current_account.can?(:read, topic)
    render :json => topic
  end

  # Creates a topic
  def create
      # Lets raise 404 if board is not available
      board = Board.find_by!(:id => create_params[:board_id])
      current_account.can?(:write, board)
      topic = board.topics.build(create_params.merge(:user => current_account))

      if topic.save and topic.errors.empty?
        render :json => topic
      else
        errors = topic.errors.messages
        render :json => {:errors => errors}, :status => 400
      end
  end

  # Updates a topic
  def update
    topic = Topic.find_by!(:id => params[:id])
    current_account.can?(:write, topic)
    topic.update_attributes(topic_params)
    render :json => topic
  end

  # Destroys a topic
  def destroy
    topic = Topic.find_by(:id => params[:id])
    can_destroy = current_account.can?(:write, topic, :raise_error => false)

    if topic and can_destroy and topic.destroy
      render :nothing => true, :status => 204
    else
      render :nothing => true, :status => 400
    end
  end

  private

    # Strong parameters for creating a new topic
    def create_params
      params.require(:topic).permit(
        :title, :description, :board_id, :project_id, :position, :whiteboard_id)
    end

    # Strong parameters for updating a topic
    def topic_params
      params.require(:topic).permit(:title, :description, :position)
    end
end
