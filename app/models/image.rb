# Image asset type class
class Image < Asset
  # Validations
  validates_presence_of :user, :board, :assetable
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES

  # Callbacks
  after_create do
    self.assetable.send(:generate_activity, Image.name) if (
      self.assetable.respond_to?(:generate_activity, true))
  end
end
