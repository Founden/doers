# DOERS [Board] [Card] class
class Card < ActiveRecord::Base
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
    self.content = Sanitize.clean(self.content) if self.content.is_a?(String)
  end
end
