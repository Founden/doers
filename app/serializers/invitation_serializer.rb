# [Invitation] model serializer
class InvitationSerializer < ActiveModel::Serializer
  include GravatarHelper

  attributes :id, :email, :project_id, :board_id, :membership_type
  attributes :avatar_url

  has_one :user, :embed => :id
  has_one :membership, :embed => :id

  # Handles serialization of membership type
  def membership_type
    object.membership_type.to_s.parameterize
  end

  # Handles project id serialization based on polymorphic relationship
  def project_id
    object.invitable.id if object.invitable.is_a?(Project)
  end

  # Handles board id serialization based on polymorphic relationship
  def board_id
    object.invitable.id if object.invitable.is_a?(Board)
  end

  # Generates avatar URL using invitation email
  def avatar_url
    gravatar_uri(object.email)
  end
end
