# DOERS [Project] [Board] class
class Board < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support
  # Available :status values for a [Board]
  STATES = ['private', 'archived']

  # Scopes
  scope :public, proc{ where(:status => STATES.last) }

  # Relationships
  belongs_to :user
  belongs_to :project
  belongs_to :whiteboard
  has_one(:cover, :class_name => Asset::Cover, :dependent => :destroy)
  has_many :cards, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities
  has_many(:memberships, :dependent => :destroy, :class_name => BoardMembership)
  has_many :members, :through => :memberships, :source => :user
  has_many :invitations, :dependent => :destroy, :as => :invitable
  has_many :topics

  # Validations
  validates_presence_of :title, :user, :project
  # Status should be one from our list
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
  after_commit :generate_activity, :on => [:create, :destroy]

  # Generates a progress out of current topics status
  def progress
    topics.count > 0 ? (
      (cards.aligned.count.to_f / topics.count) * 100).to_i : 100
  end
end
