# DOERS range [Card] STI class
class Card::Interval < Card
  # Store accessors definition
  store_accessor :data, :minimum, :maximum, :selected

  # Validations
  validates_presence_of :title, :minimum, :maximum, :selected
  validates_numericality_of :minimum, :less_than => :maximum
  validates_numericality_of :maximum, :greater_than => :minimum
  validates_numericality_of :selected, :greater_than_or_equal_to => :minimum
  validates_numericality_of :selected, :less_than_or_equal_to => :maximum

  # Callbacks
  # Sanitize user input
  before_validation do
    self.minimum = Float(self.minimum).round(3) rescue self.minimum
    self.maximum = Float(self.maximum).round(3) rescue self.maximum
    self.selected = Float(self.selected).round(3) rescue self.selected
  end
end
