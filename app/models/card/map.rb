# DOERS map [Card] STI class
class Card::Map < Card
  # Store accessors definition
  store_accessor :data, :latitude, :longitude

  # Relationships
  belongs_to :parent_card, :class_name => Card::Map
  has_many(:versions, :class_name => Card::Map,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates_presence_of :content
end
