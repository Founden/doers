# DOERS map [Field] STI class
class Field::Map < Field
  # Store accessors definition
  store_accessor :data, :location, :address, :latitude, :longitude

  # Validations
  validates_presence_of :location, :address

  # Callbacks
  # Sanitize user input
  before_validation do
    self.location = Sanitize.clean(self.location)
    self.address = Sanitize.clean(self.address)
  end
end
