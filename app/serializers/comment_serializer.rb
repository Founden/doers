# [Comment] model serializer
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :external_author_name, :updated_at
  attributes :card_id

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_one :parent_comment, :embed => :id
  has_many :comments, :embed => :id

  # Handles card id serialization based on polymorphic relationship
  def card_id
    object.commentable.id if object.commentable.is_a?(Card)
  end
end
