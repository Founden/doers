# Image asset type class
class Image < Asset
  # Validations
  validates_presence_of :user, :board, :assetable
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
