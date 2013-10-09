# Avatar asset type class
class Asset::Avatar < Asset
  # Attachment overwrite
  has_attached_file :attachment, :styles => Doers::Config.assets.image.sizes

  # Validations
  validates_presence_of :user
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
