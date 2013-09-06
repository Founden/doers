# DOERS [Membership] class
class Membership < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Relationships
  belongs_to :creator, :class_name => User
  belongs_to :user
  belongs_to :board
  belongs_to :project
  has_one :invitation

  # Validations
  validates_presence_of :user, :creator
end
