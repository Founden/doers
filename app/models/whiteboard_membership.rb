# DOERS [Membership] class for whiteboard collaborators
class WhiteboardMembership < Membership
  # Validations
  validates_presence_of :whiteboard
  validates_exclusion_of :whiteboard_id, :in => :user_whiteboard_ids

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]

  # Target to use when generating activities
  def activity_owner
    self.whiteboard
  end

  private
    # Membership user whiteboard ids
    def user_whiteboard_ids
      self.user ? self.user.whiteboard_ids : []
    end
end
