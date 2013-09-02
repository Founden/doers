# DOERS [Invitation] class
class Invitation < ActiveRecord::Base
  # Allowed memberships
  ALLOWED_MEMBERSHIPS = %w(Membership::Project Membership::Board) + [nil]
  # Allowed memberships
  ALLOWED_INVITABLES = %w(Project Board) + [nil]

  # Relationships
  belongs_to :user
  belongs_to :membership, :polymorphic => true
  belongs_to :invitable, :polymorphic => true

  # Validations
  validates_presence_of :user, :email
  validates_presence_of :membership_type, :if => :invitable
  validates_presence_of :invitable, :if => :membership_type
  validates_uniqueness_of :email
  validates_inclusion_of(:membership_type, :in => ALLOWED_MEMBERSHIPS)
  validates_inclusion_of(:invitable_type, :in => ALLOWED_INVITABLES)
  # Callbacks
  before_validation do
    self.membership_type ||= self.invitable.memberships.klass if self.invitable
  end
end
