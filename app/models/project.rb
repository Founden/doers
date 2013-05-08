# DOERS [Project] class
class Project < ActiveRecord::Base
  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # Relationships
  belongs_to :user
  has_many :personas, :class_name => Board::Persona
  has_many :problems, :class_name => Board::Problem
  has_many :solutions, :class_name => Board::Solution
  has_many :fields

  # Validations
  validates :user, :presence => true
  validates :title, :presence => true
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
end
