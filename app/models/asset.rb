# DOERS [Asset] STI model
class Asset < ActiveRecord::Base
  # List of allowed mime-types for image uploads
  IMAGE_TYPES = %w( image/jpeg image/png image/gif image/pjpeg image/x-png )

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :user
  belongs_to :assetable, :polymorphic => true

  # Validations
  validates_presence_of :user, :project
  validates_attachment_presence :attachment

  # Callbacks
  before_validation do
    self.description = Sanitize.clean(self.description)
  end
end
