# DOERS [Board] [Field] class
class Field < ActiveRecord::Base
  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON

  # Relationships
  belongs_to :user
  belongs_to :project

  # Validations
  validates_presence_of :user, :project

  # Callbacks
  after_initialize do
    self.position ||= 0
  end
end
