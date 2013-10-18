# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description
  attributes :topics_count, :progress

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :whiteboard, :embed => :id
  has_one :cover, :embed => :id

  has_many :activities, :embed => :id
  has_many :memberships, :embed => :id
  has_many :topics, :embed => :id

  # Returns the number of topics
  def topics_count
    object.topics.count
  end
end
