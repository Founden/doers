# DOERS [Project] [Board] class
class Board < ActiveRecord::Base
  # Available :status values for a [Board]
  STATES = ['published', 'trashed']

  # Relationships
  belongs_to :user
  belongs_to :project
  has_many :fields

  # Validations
  validates_presence_of :user, :project, :title
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
    self.position ||= 0
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
  end
end
