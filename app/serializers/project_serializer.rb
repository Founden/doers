# [Project] model serializer
class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :website
  attributes :last_update

  has_one :user, :embed => :id
  has_one :logo, :embed => :id
  has_many :boards, :embed => :ids

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end
end
