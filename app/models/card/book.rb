# DOERS book [Card] model
class Card::Book < Card
  # Relationships
  has_one(:image, :dependent => :destroy,
          :as => :assetable, :class_name => Asset::Image)
  belongs_to :parent_card, :class_name => Card::Book
  has_many(:versions, :class_name => Card::Book,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Store accessors definition
  store_accessor :data, :url, :book_title, :book_authors

  # Validations
  validates_presence_of :book_title, :book_authors
end
