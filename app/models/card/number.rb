# DOERS number [Card] STI class
class Card::Number < Card
  # Store accessors definition
  store_accessor :data, :content

  # Validations
  validates :content, :numericality => true, :presence => true
end
