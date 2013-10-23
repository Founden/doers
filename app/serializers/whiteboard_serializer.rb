# [Whiteboard] model serializer
class WhiteboardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :collections
  attributes :topics_count, :boards_count

  has_one :user, :embed => :id
  has_one :team, :embed => :id
  has_one :cover, :embed => :id
  has_many :topics, :embed => :id
  has_many :activities, :embed => :id

  # Returns collection/tag names
  def collections
    object.tags.pluck('name').map(&:titleize)
  end

  # Returns the number of topics
  def topics_count
    object.topics.count
  end

  # Returns the number of boards
  def boards_count
    object.boards.count
  end
end
