# DOERS number [Card] STI class
class Card::Number < Card
  # Store accessors definition
  store_accessor :data, :number

  # Validations
  validates :number, :numericality => true, :presence => true

  # Callbacks
  # Sanitize user input
  before_validation do
    self.number = Float(self.number).round(3) rescue self.number
  end
end
