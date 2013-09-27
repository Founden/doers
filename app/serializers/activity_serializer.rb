# [Activity] model serializer
class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :slug, :updated_at, :last_update
  attributes :user_name, :project_title, :board_title, :topic_title, :card_title

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_one :card, :embed => :id
  has_one :topic, :embed => :id
  has_one :comment, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end
end
