# DOERS [Membership] class for board collaborators
class Membership::Board < Membership
  # Relationships
  belongs_to :board

  # Validations
  validates_presence_of :board
end
