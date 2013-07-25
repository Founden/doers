# DOERS map [Card] STI class
class Card::Map < Card
  # Store accessors definition
  store_accessor :data, :latitude, :longitude

  # Validations
  validates_presence_of :content
end
