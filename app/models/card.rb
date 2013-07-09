# DOERS [Board] [Card] class
class Card < ActiveRecord::Base
  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON

  # Relationships
  belongs_to :user
  belongs_to :board
  belongs_to :project

  # Validations
  validates_presence_of :title, :user, :board

  # Callbacks
  after_initialize do
    self.position ||= 0
  end
  # Sanitize user input
  before_validation do
    self.title = Sanitize.clean(self.title)
  end
end
