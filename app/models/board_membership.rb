# DOERS [Membership] class for board collaborators
class BoardMembership < Membership
  # Relationships
  has_many :invitations, :as => :membership
  has_many :activities, :as => :trackable

  # Validations
  validates_presence_of :board
  validates_exclusion_of :board_id, :in => :user_board_ids

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]

  private
    # Membership user board ids
    def user_board_ids
      user ? self.user.boards.pluck('id') + user.authored_board_ids : []
    end
end
