require 'uri'

# DOERS link [Card] model
class Card::Link < Card
  ALLOWED_SCHEMES = %w(http https)

  # Store accessors definition
  store_accessor :data, :url, :excerpt

  # Validations
  validates_presence_of :excerpt
  validates_format_of :url, :with => URI.regexp(ALLOWED_SCHEMES)

  # Callbacks
  # Sanitize user input
  before_validation do
    self.excerpt = Sanitize.clean(self.excerpt)
  end
end
