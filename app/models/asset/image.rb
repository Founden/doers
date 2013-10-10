# Image asset type class
class Asset::Image < Asset
  # Attachment overwrite
  has_attached_file(
    :attachment, :styles => Doers::Config.assets.image.sizes.except('thumb'))

  # Validations
  validates_presence_of :user, :board, :assetable
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES

  # Callbacks
  after_create do
    self.assetable.send(:generate_activity, Asset::Image.name) if (
      self.assetable.respond_to?(:generate_activity, true))
  end
end
