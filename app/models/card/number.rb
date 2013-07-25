# DOERS number [Card] STI class
class Card::Number < Card
  # Validations
  validates :content, :numericality => true, :presence => true

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Float(self.content).round(3) rescue self.content
  end
end
