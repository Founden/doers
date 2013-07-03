# DOERS photo [Card] model
class Card::Photo < Card
  # Relationships
  has_one :image, :dependent => :destroy, :foreign_key => :assetable_id
end
