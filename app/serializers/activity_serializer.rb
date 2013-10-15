# [Activity] model serializer
class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :slug, :updated_at, :user_name, :project_title
  attributes :board_title, :topic_title, :card_title

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_one :card, :embed => :id
  has_one :topic, :embed => :id
  has_one :comment, :embed => :id
end
