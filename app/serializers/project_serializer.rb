# [Project] model serializer
class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :website
  attributes :last_update, :logo_url, :user_nicename

  has_one :user, :embed => :id
  has_many :boards, :embed => :ids

  # Get logo URL from attachment
  def logo_url
    object.logo.attachment.url if object.logo
  end

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
  end
end
