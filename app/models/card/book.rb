# DOERS book [Card] model
class Card::Book < Card
  # Relationships
  has_one :image, :dependent => :destroy, :as => :assetable

  # Store accessors definition
  store_accessor :data, :url, :book_title, :book_authors

  # Validations
  validates_presence_of :book_title, :book_authors
end
