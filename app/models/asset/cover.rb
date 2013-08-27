# Cover asset type class
class Asset::Cover < Asset
  # Validations
  validates_presence_of :user, :board
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
