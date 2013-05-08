# DOERS Problem [Board] STI class
class Board::Problem < Field
  # Relationships
  belongs_to :persona, :class_name => Board::Persona, :foreign_key => :board_id

  # Validations
  validates_presence_of(:persona)
end
