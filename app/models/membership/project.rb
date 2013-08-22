# DOERS [Membership] class for project collaborators
class Membership::Project < Membership
  # Relationships
  belongs_to :project

  # Validations
  validates_presence_of :project
end
