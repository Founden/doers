# DOERS [Invitation] class
class Invitation < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Allowed memberships
  ALLOWED_MEMBERSHIPS = %w(Membership::Project Membership::Board) + [nil]
  # Allowed memberships
  ALLOWED_INVITABLES = %w(Project Board) + [nil]

  # Relationships
  belongs_to :user
  belongs_to :membership, :polymorphic => true
  belongs_to :invitable, :polymorphic => true
  has_many :activities, :as => :trackable

  # Validations
  validates_presence_of :user, :email
  validates_presence_of :membership_type, :if => :invitable
  validates_presence_of :invitable, :if => :membership_type
  validates_uniqueness_of :email
  validates_inclusion_of(:membership_type, :in => ALLOWED_MEMBERSHIPS)
  validates_inclusion_of(:invitable_type, :in => ALLOWED_INVITABLES)
  # Callbacks
  before_validation do
    self.membership_type ||=
      self.invitable.memberships.klass.name if self.invitable
  end
  after_commit :generate_activity, :on => [:create]
  after_commit :email_invite, :on => [:create]

  private

    # Emails the invitation
    def email_invite
      UserMailer.delay.invite(self)
    end
end
