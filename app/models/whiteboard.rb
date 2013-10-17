# DOERS [Whiteboard] class
class Whiteboard < ActiveRecord::Base
  # Relationships
  belongs_to :user
  belongs_to :team
  has_one(:cover, :class_name => Asset::Cover, :dependent => :destroy)
  has_many :boards
  has_many :comments, :dependent => :destroy
  has_many :activities
  has_many :topics
  # Tagging support
  has_many_tags

  # Validations
  validates_presence_of :title
  # Require a user on non shared board
  validates_presence_of :user

  # Callbacks
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
  after_commit :generate_activity, :on => [:create, :destroy]
end
