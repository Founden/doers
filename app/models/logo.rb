# Logo asset type class
class Logo < Asset
  has_attached_file :attachment

  # Validations
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES
end
