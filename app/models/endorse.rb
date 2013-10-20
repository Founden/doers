# DOERS [Endorse] class
class Endorse < Activity
  # Include [Activity] generations support
  include Activity::Support

  # Validations
  validates_presence_of :board, :topic, :card

  # Callbacks
  before_validation do
    self.slug = activity_slug
  end
  after_commit :generate_activity, :on => [:destroy]

  # Target to use when generating activities
  def activity_owner
    self.card
  end
end
