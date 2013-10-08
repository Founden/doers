# DOERS [Endorse] class
class Endorse < Activity
  include Activity::Support

  # Validations
  validates_presence_of :board, :topic, :card

  # Callbacks
  before_validation do
    self.slug = activity_slug
  end
end
