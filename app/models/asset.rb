# DOERS [Asset] STI model
class Asset < ActiveRecord::Base
  # List of allowed URI schemes
  URI_REGEXP = URI.regexp %w(http https ftp)
  # List of allowed mime-types for image uploads
  IMAGE_TYPES = %w( image/jpeg image/png image/gif image/pjpeg image/x-png )

  has_attached_file :attachment

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :whiteboard
  belongs_to :user
  belongs_to :assetable, :polymorphic => true

  # Validations
  validates_attachment_presence :attachment

  # Callbacks
  before_validation do
    self.description = Sanitize.clean(self.description)
  end
end
