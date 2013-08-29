# DOERS date [Card] STI class
class Card::Timestamp < Card
  # Relationships
  belongs_to :parent_card, :class_name => Card::Timestamp
  has_many(:versions, :class_name => Card::Timestamp,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates_presence_of :content

  # Callbacks
  before_validation do
    self.content = DateTime.parse(self.content).to_s rescue nil
  end
end
