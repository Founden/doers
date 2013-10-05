# [Topic] model serializer
class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :updated_at, :last_update

  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_many :comments, :embed => :id
  has_many :activities, :embed => :id
  has_one :card, :embed => :id

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
