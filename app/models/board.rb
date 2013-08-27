# DOERS [Project] [Board] class
class Board < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support
  # Available :status values for a [Board]
  STATES = ['private', 'public']

  # Scopes
  scope :public, proc{ where(:status => STATES.last) }

  # Relationships
  belongs_to :user
  belongs_to :author, :class_name => User
  belongs_to :project
  belongs_to :parent_board, :class_name => Board
  has_many :branches, :class_name => Board, :foreign_key => :parent_board_id
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user

  # Validations
  validates_presence_of :title
  # Require an author on initial creation
  validates_presence_of :author, :unless => :parent_board
  # Require a project on `branch-ing`
  validates_presence_of :project, :if => :parent_board
  # Require a user on `branch-ing`
  validates_presence_of :user, :if => :parent_board
  # Status should be one from our list
  validates :status, :inclusion => {:in => STATES}
  # Do not create multiple branches of the same parent board
  validates :parent_board_id,
    :uniqueness => {:scope => :project_id}, :if => :has_public_parent_board?

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
  after_commit :generate_activity, :on => [:create, :destroy]

  # Handles boards branching for a user an a project
  # @param user [User] the branching user
  # @param project [Project] the project to branch into
  # @param params [Hash] the parameters like :title to include
  # @return [Board] the new branch
  def branch_for(user, project, params)
    raise _('Board is not available') if !user.can?(:read, self)
    raise _('Project is not available') if !user.projects.include?(project)

    board = branches.create(
      :title => params[:title], :user => user, :project => project)
    # Forking the cards
    self.cards.each do |card|
      attrs = card.attributes.except('id', 'created_at', 'updated_at')
      attrs.merge!(:user => user, :project => project)
      board.cards.create(attrs)
    end unless board.new_record?
    board
  end

  private

  # Checks if parent boards is public
  def has_public_parent_board?
    self.parent_board && self.parent_board.status.eql?(STATES.last)
  end
end
