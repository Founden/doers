# Logo asset type class
class Asset::Logo < Asset
  # Validations
  validates_presence_of :user, :project
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
