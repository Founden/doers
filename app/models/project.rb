# DOERS [Project] class
class Project < ActiveRecord::Base
  STATES = ['private', 'public', 'archived']

  # Relationships
  belongs_to :user

  # Validations
  validates :title, :presence => true
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
end
