# DOERS [Invitation] class
class Invitation < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Allowed memberships
  ALLOWED_MEMBERSHIPS = %w(ProjectMembership BoardMembership) + [nil]
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
  validates_inclusion_of(
    :invitable_id, :in => :user_project_ids, :if => [:user, :for_project?])
  validates_inclusion_of(
    :invitable_id, :in => :user_board_ids, :if => [:user, :for_board?])
  # Callbacks
  before_validation do
    self.membership_type ||=
      self.invitable.memberships.klass.name if self.invitable
  end
  after_commit :generate_activity, :on => [:create]
  after_commit :email_invite, :on => [:create]

  # Sugaring to check if invitation is claimed
  def claimer
    User.find_by(:email => self.email)
  end

  # Sugaring to help validation of an invitable project
  def for_project?
    self.invitable.is_a?(Project)
  end

  # Sugaring to help validation of an invitable board
  def for_board?
    self.invitable.is_a?(Board)
  end

  # Target to use when generating activities
  def activity_owner
    self.invitable.respond_to?(:activities) ? self.invitable : self.user
  end

  private

    # Emails the invitation
    def email_invite
      UserMailer.delay.invite(self)
    end

    # Project ids user created
    def user_project_ids
      self.user.created_project_ids + [nil]
    end

    # Board ids user branched/authored
    def user_board_ids
      self.user.created_board_ids + self.user.shared_board_ids + [nil]
    end
end
