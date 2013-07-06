# DOERS [Project] [Board] class
class Board < ActiveRecord::Base
  # Available :status values for a [Board]
  STATES = ['private', 'public']

  # Relationships
  belongs_to :user
  belongs_to :author, :class_name => User
  belongs_to :project
  belongs_to :parent_board, :class_name => Board
  has_many :branches, :class_name => Board, :foreign_key => :parent_board_id
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  # Validations
  validates_presence_of :title
  # Require an author on initial creation
  validates_presence_of :author, :unless => :parent_board
  # Require a project on `branch-ing`
  validates_presence_of :project, :if => :parent_board
  # Require a user on `branch-ing`
  validates_presence_of :user, :if => :parent_board
  validates :status, :inclusion => {:in => STATES}

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
end
