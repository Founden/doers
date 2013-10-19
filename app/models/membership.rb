# DOERS [Membership] class
class Membership < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Relationships
  belongs_to :creator, :class_name => User
  belongs_to :user
  belongs_to :board
  belongs_to :whiteboard
  belongs_to :project
  has_one :invitation, :dependent => :destroy

  # Validations
  validates_presence_of :user, :creator

  # Callbacks
  after_commit :notify_member, :on => :create

  # Target to use when generating activities
  def activity_title
    self.user.nicename
  end

  private

    # Sends an email with details about the new membership
    def notify_member
      UserMailer.delay.membership_notification(self)
    end
end
