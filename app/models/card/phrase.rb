# DOERS phrase [Card] STI class
class Card::Phrase < Card
  # Relationships
  belongs_to :parent_card, :class_name => Card::Phrase
  has_many(:versions, :class_name => Card::Phrase,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates_presence_of :content
end
