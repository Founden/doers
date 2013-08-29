# DOERS photo [Card] model
class Card::Photo < Card
  # Relationships
  has_one(:image, :dependent => :destroy, :as => :assetable,
          :class_name => Asset::Image)
  belongs_to :parent_card, :class_name => Card::Photo
  has_many(:versions, :class_name => Card::Photo,
           :dependent => :destroy, :foreign_key => :parent_card_id)
end
