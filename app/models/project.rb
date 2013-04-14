# DOERS [Project] class
class Project < ActiveRecord::Base
  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # Relationships
  belongs_to :user

  # Validations
  validates :user, :presence => true
  validates :title, :presence => true
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
end
