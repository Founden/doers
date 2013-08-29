# DOERS paragraph area [Card] STI class
class Card::Paragraph < Card
  # Relationships
  belongs_to :parent_card, :class_name => Card::Paragraph
  has_many(:versions, :class_name => Card::Paragraph,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates_presence_of :content
end
