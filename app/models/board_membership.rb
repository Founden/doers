# DOERS [Membership] class for board collaborators
class BoardMembership < Membership
  # Validations
  validates_presence_of :board
  validates_exclusion_of :board_id, :in => :user_board_ids

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]

  # Target to use when generating activities
  def activity_owner
    self.board
  end

  private
    # Membership user board ids
    def user_board_ids
      user ? self.user.boards.pluck('id') + user.authored_board_ids : []
    end
end
