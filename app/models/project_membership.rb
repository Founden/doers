# DOERS [Membership] class for project collaborators
class ProjectMembership < Membership
  # Relationships
  has_many :invitations, :as => :membership
  has_many :activities, :as => :trackable

  # Validations
  validates_presence_of :project
  validates_exclusion_of :project_id, :in => :user_project_ids

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]

  private
    # Membership user project ids
    def user_project_ids
      user ? self.user.projects.pluck('id') : []
    end
end
