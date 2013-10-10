# Logo asset type class
class Asset::Logo < Asset
  # Attachment overwrite
  has_attached_file(
    :attachment, :styles => Doers::Config.assets.image.sizes.except('medium'))

  # Validations
  validates_presence_of :user, :project
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
