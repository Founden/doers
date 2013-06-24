# DOERS text area [Card] STI class
class Card::TextArea < Card
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
