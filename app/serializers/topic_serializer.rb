# [Topic] model serializer
class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :updated_at
  attributes :activity_ids, :last_update

  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_many :comments, :embed => :id

  # Fetches topic board activity ids
  def activity_ids
    return [] if options[:topic_board_id].blank?
    object.activities.where(:board_id => options[:topic_board_id]).pluck('id')
  end

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # Method to use for aliasing what attributes can be included
  def user_is_allowed?
    current_account.can?(:write, object.board, :raise_error => false)
  end
  alias_method :include_comments?, :user_is_allowed?
  alias_method :include_activities?, :user_is_allowed?
end
