# DOERS photo [Card] model
class Card::Photo < Card
  # Relationships
  has_one :image, :dependent => :destroy, :as => :assetable
end
