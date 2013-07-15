# DOERS phrase [Card] STI class
class Card::Phrase < Card
  # Store accessors definition
  store_accessor :data, :content

  # Validations
  validates_presence_of :content

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Sanitize.clean(self.content)
  end
end
