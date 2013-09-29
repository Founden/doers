# [Comment] model serializer
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :external_author_name, :updated_at

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_one :topic, :embed => :id
  has_one :card, :embed => :id
  has_one :parent_comment, :embed => :id
  has_many :comments, :embed => :id
end
