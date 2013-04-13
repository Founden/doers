# DOERS [Board] [Panel] class
class Panel < ActiveRecord::Base
  # Available :status values for a [Panel]
  STATES = ['draft', 'default']

  # Relationships
  belongs_to :user

  # Validations
  validates :label, :uniqueness => true, :presence => true
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
    self.position ||= 0
  end
end
