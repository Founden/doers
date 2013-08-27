# DOERS number [Card] STI class
class Card::Number < Card
  # Store accessors definition
  store_accessor :data, :number

  # Relationships
  belongs_to :parent_card, :class_name => Card::Number
  has_many(:versions, :class_name => Card::Number,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates :number, :numericality => true, :presence => true

  # Callbacks
  # Sanitize user input
  before_validation do
    self.number = Float(self.number).round(3) rescue self.number
  end
end
