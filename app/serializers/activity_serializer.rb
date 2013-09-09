# [Activity] model serializer
class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :slug, :updated_at, :last_update
  attributes :user_name, :project_title, :board_title, :trackable_title
  attributes :trackable_id, :trackable_type, :comment_id

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end
end
