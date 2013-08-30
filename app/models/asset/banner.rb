# Logo asset type class
class Asset::Banner < Asset
  # Validations
  validates_presence_of :assetable
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
