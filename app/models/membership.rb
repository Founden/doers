# DOERS [Membership] class
class Membership < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Relationships
  belongs_to :creator, :class_name => User
  belongs_to :user
  belongs_to :board
  belongs_to :project
  has_many :activities, :as => :trackable

  # Validations
  validates_presence_of :user, :creator

  # Callbacks
  after_commit :generate_activity, :on => [:create, :destroy]
end

# This is due to avoid auto-loading-thinga-magic rails shits
require_relative 'membership/board'
require_relative 'membership/project'
