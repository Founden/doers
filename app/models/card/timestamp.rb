# DOERS date [Card] STI class
class Card::Timestamp < Card
  # Store accessors definition
  store_accessor :data, :timestamp

  # Validations
  validates_presence_of :timestamp

  # Callbacks
  # Sanitize user input
  before_validation do
    self.timestamp = DateTime.parse(self.timestamp).to_s rescue nil
  end
end
