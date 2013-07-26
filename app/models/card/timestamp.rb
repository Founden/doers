# DOERS date [Card] STI class
class Card::Timestamp < Card
  # Validations
  validates_presence_of :content

  # Callbacks
  before_validation do
    self.content = DateTime.parse(self.content).to_s rescue nil
  end
end
