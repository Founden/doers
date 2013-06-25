# DOERS numeric [Card] STI class
class Card::Numerics < Card
  # Store accessors definition
  store_accessor :data, :minimum, :maximum, :selected

  # Validations
  validates_presence_of :title, :minimum, :maximum, :selected
  validates_numericality_of :minimum, :less_than => :maximum
  validates_numericality_of :maximum, :greater_than => :minimum
  validates_numericality_of :selected, :greater_than_or_equal_to => :minimum
  validates_numericality_of :selected, :less_than_or_equal_to => :maximum
end