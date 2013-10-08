# DOERS [Endorse] class
class Endorse < Activity
  include Activity::Support

  # Callbacks
  before_validation do
    self.slug = activity_slug
  end
end
