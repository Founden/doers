require 'uri'

# DOERS link [Card] model
class Card::Link < Card
  # List of allowed URI schemes
  ALLOWED_SCHEMES = %w(http https)

  # Validations
  validates_presence_of :content
  validates_format_of :content, :with => URI.regexp(ALLOWED_SCHEMES)
end
