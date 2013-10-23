# [Topic] model serializer
class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :updated_at

  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_many :cards, :embed => :id
  has_many :comments, :embed => :id
  has_many :activities, :embed => :id

end
