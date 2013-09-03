# [Invitation] model serializer
class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :email, :project_id, :board_id, :membership_type

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
end
