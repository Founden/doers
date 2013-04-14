# DOERS [Project] [Board] class
class Board < ActiveRecord::Base
  # Available :status values for a [Board]
  STATES = ['published', 'trashed']

  # Relationships
  belongs_to :user
  belongs_to :project
  belongs_to :panel
  has_many :fields

  # Validations
  validates_presence_of :user, :panel, :project, :title
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
    self.position ||= 0
  end
end
