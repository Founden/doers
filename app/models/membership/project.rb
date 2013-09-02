# DOERS [Membership] class for project collaborators
class Membership::Project < Membership
  # Relationships
  has_many :invitations, :as => :membership

  # Validations
  validates_presence_of :project
  validates_exclusion_of :project, :in => :user_project_ids

  private
    # Membership user project ids
    def user_project_ids
      user ? self.user.projects.pluck('id') : []
    end
end
