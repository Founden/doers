# DOERS [User] class
class User < ActiveRecord::Base
  # Include [User] authorization support
  include User::Authorization
  # Include support for authentication
  include EasyAuth::Models::Account
  # Include [Activity] generations support
  include Activity::Support
  # Include [Activity] listening support
  include Activity::Listener

  # Possible user interests
  INTERESTS = {
    _('Founder') => 'founder',
    _('Investor') => 'investor',
    _('Advisor') => 'advisor',
    _('Domain Expert') => 'expert',
    _('Running an Accelerator') => 'owner'
  }

  store_accessor :data, :confirmed, :interest, :company
  store_accessor :data, :importing, :newsletter_allowed
  store_accessor :data, :promo_code

  # Relationships
  has_many :cards
  has_many :comments
  has_many :assets
  has_many :images, :class_name => Asset::Image
  has_many :activities

  has_many(:memberships, :dependent => :destroy)
  has_many(:created_memberships, :dependent => :destroy,
           :foreign_key => :creator_id, :class_name => Membership)
  has_many :project_memberships, :dependent => :destroy
  has_many :whiteboard_memberships, :dependent => :destroy
  has_many :board_memberships, :dependent => :destroy

  has_many :invitations, :dependent => :destroy
  has_many :whiteboards
  has_many(:shared_whiteboards, :class_name => Whiteboard,
           :through => :whiteboard_memberships, :source => :whiteboard)
  has_many :boards
  has_many(:shared_boards, :class_name => Board,
           :through => :board_memberships, :source => :board)

  has_many :created_projects, :class_name => Project, :dependent => :destroy
  has_many(
    :shared_projects, :through => :project_memberships, :source => :project)
  has_many :topics
  has_many :endorses, :dependent => :destroy
  has_one :avatar, :class_name => Asset::Avatar, :dependent => :destroy

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  before_create :notify_invitation_creator
  after_commit :generate_activity, :on => :create

  # All user projects
  def projects
    Project.where(:id => (shared_project_ids + created_project_ids))
  end

  # Helper to generate the user name
  def nicename
    name || email
  end

  # Checks if user is confirmed
  def confirmed?
    !confirmed.blank?
  end

  # Allows newsletter to be sent?
  def newsletter_allowed?
    newsletter_allowed.nil? ? true : newsletter_allowed
  end

  # Check if user can administrate things
  def admin?
    !Doers::Config.admin_regex.match(email).blank?
  end

  # Claims available invitations and builds memberships
  def claim_invitation
    invite = Invitation.find_by(:email => self.email)
    if invite and invite.invitable and invite.membership_id.blank?
      self.update_attribute(:confirmed, 1)
      invite.membership = invite.invitable.memberships.create(
        :creator => invite.user, :user => self)
      invite.save
      invite
    end
  end

  # This is called as before hook by [Activity::Listener]
  def before_listen
    touch(:login_at)
  end

  # This is called as after hook by [Activity::Listener]
  def after_listen
    toggle!(:login_at)
  end

  private

  # Send a notification to the one who invited the user
  def notify_invitation_creator
    if invitation = Invitation.find_by(:email => self.email)
      UserMailer.delay.invitation_claimed(invitation, self)
    end
  end

end
