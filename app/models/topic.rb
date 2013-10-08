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
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities
  has_many :endorses, :dependent => :destroy

  # Validations
  validates_presence_of :title, :user, :board

  # Callbacks
  after_initialize do
    self.position ||= 0
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
    # Topic should belong only to authored boards
    self.board = nil if self.board and self.board.author.nil?
  end
  after_commit :generate_activity
end
