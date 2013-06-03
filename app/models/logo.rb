require 'open-uri'

# Logo asset type class
class Logo < Asset
  has_attached_file :attachment

  # Validations
  validates_attachment_content_type :attachment, :content_type => IMAGE_TYPES

  # Callbacks
  before_validation :download_from_remote_url?, :if => :remote_url?

  private

  # Validate image url if provided
  def remote_url?
    !self.attachment_remote_url.blank?
  end

  # Downloads the provided url data
  def download_from_remote_url
    io = open(URI.parse(self.attachment_remote_url))
    self.original_filename = io.base_uri.path.split('/').last
    self.attachment = io
  rescue
    false
  end
end
