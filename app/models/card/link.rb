require 'uri'

# DOERS link [Card] model
class Card::Link < Card
  # List of allowed URI schemes
  ALLOWED_SCHEMES = %w(http https)

  # Relationships
  belongs_to :parent_card, :class_name => Card::Link
  has_many(:versions, :class_name => Card::Link,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Store accessors definition
  store_accessor :data, :url

  # Validations
  validates_presence_of :content
  validates_format_of :url, :with => URI.regexp(ALLOWED_SCHEMES)
end
