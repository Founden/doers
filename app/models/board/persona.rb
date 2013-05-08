# DOERS Persona [Board] STI class
class Board::Persona < Field
  # Relationships
  has_one :problem, :class_name => Board::Problem
  has_one :solution, :class_name => Board::Solution
end
