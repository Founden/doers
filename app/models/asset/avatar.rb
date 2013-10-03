# Avatar asset type class
class Asset::Avatar < Asset
  # Validations
  validates_presence_of :user
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
