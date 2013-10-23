# DOERS [Board] [Topic] class
class Topic < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Default scope: order by position
  default_scope { order(:position) }

  # Relationships
  belongs_to :user
  belongs_to :project
  belongs_to :board
  belongs_to :whiteboard
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities

  # Validations
  validates_presence_of :title, :user
  validates_presence_of :board, :unless => :whiteboard
  validates_presence_of :whiteboard, :unless => :board

  # Callbacks
  after_initialize do
    self.position ||= 0
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
  after_commit :generate_activity
end
