# Cover asset type class
class Asset::Cover < Asset
  # Validations
  validates_presence_of :user
  validates_presence_of :whiteboard, :unless => :board
  validates_presence_of :board, :unless => :whiteboard
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
