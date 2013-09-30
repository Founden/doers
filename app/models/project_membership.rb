# DOERS [Membership] class for project collaborators
class ProjectMembership < Membership
  # Relationships
  has_many :invitations, :as => :membership

  # Validations
  validates_presence_of :project
  validates_exclusion_of :project_id, :in => :user_project_ids

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]

  # Target to use when generating activities
  def activity_owner
    self.project
  end

  private
    # Membership user project ids
    def user_project_ids
      user ? self.user.projects.pluck('id') : []
    end
end
