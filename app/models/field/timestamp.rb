# DOERS date [Field] STI class
class Field::Timestamp < Field
  # Store accessors definition
  store_accessor :data, :title, :timestamp

  # Validations
  validates_presence_of :title, :timestamp

  # Callbacks
  # Sanitize user input
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.timestamp = DateTime.parse(self.timestamp).to_s rescue nil
  end
end
