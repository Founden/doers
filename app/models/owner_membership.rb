# DOERS [Membership] class for project|board owners
class OwnerMembership < Membership
  # Validations
  validates_presence_of :project
  validates_inclusion_of :project_id, :in => :user_project_ids

  # Callbacks
  skip_callback :commit, :after, :notify_member

  private
    # Membership user project ids
    def user_project_ids
      user ? self.user.created_project_ids : []
    end
end
