# Cover asset type class
class Asset::Cover < Asset
  # Attachment overwrite
  has_attached_file(
    :attachment, :styles => Doers::Config.assets.cover.sizes)

  # Validations
  validates_presence_of :user
  validates_presence_of :whiteboard, :unless => :board
  validates_presence_of :board, :unless => :whiteboard
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
