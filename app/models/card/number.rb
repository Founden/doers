# DOERS number [Card] STI class
class Card::Number < Card
  # Store accessors definition
  store_accessor :data, :content

  # Validations
  validates :content, :numericality => true, :presence => true

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Float(self.content).round(3) rescue self.content
  end
end
