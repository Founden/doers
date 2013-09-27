# DOERS phrase [Card] STI class
class Card::Phrase < Card
  # Validations
  validates_presence_of :content
end
