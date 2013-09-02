# DOERS [Membership] class for board collaborators
class Membership::Board < Membership
  # Relationships
  has_many :invitations, :as => :membership

  # Validations
  validates_presence_of :board
  validates_exclusion_of :board, :in => :user_board_ids

  private
    # Membership user board ids
    def user_board_ids
      user ? self.user.boards.pluck('id') + user.authored_board_ids : []
    end
end
