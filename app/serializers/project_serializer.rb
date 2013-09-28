# [Project] model serializer
class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :website
  attributes :last_update, :boards_count, :members_count

  has_one :user, :embed => :id
  has_one :logo, :embed => :id
  has_many :boards, :embed => :ids
  has_many :activities, :embed => :id
  has_many :memberships, :embed => :id
  has_many :invitations, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # Project boards count
  def boards_count
    object.boards.count
  end

  # Project members count
  def members_count
    object.members.count
  end
end
