# DOERS [User] class
class User < ActiveRecord::Base
  # Include [User] authorization support
  include User::Authorization
  # Include support for authentication
  include EasyAuth::Models::Account
  # Include [Activity] generations support
  include Activity::Support

  INTERESTS = {
    _('Founder') => 'founder',
    _('Investor') => 'investor',
    _('Advisor') => 'advisor',
    _('Domain Expert') => 'expert',
    _('Running an Accelerator') => 'owner'
  }

  store_accessor :data, :confirmed, :interest, :company
  store_accessor :data, :importing, :newsletter_allowed

  # Relationships
  has_many :cards
  has_many :comments
  has_many :assets
  has_many :images, :class_name => Asset::Image
  has_many :activities
  has_many(:created_memberships, :dependent => :destroy,
           :foreign_key => :creator_id, :class_name => Membership)
  has_many(:accepted_memberships, :dependent => :destroy,
           :class_name => Membership)
  has_many :invitations, :dependent => :destroy

  has_many :branched_boards, :class_name => Board
  has_many :authored_boards, :foreign_key => :author_id, :class_name => Board
  has_many :shared_boards, :through => :accepted_memberships, :source => :board

  has_many :created_projects, :class_name => Project, :dependent => :destroy
  has_many(
    :shared_projects, :through => :accepted_memberships, :source => :project)
  has_many :topics
  has_one :avatar, :class_name => Asset::Avatar, :dependent => :destroy

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  before_create :notify_invitation_creator
  after_commit :generate_activity, :on => :create
  after_commit :send_confirmation_email, :on => :update

  # All user projects
  def projects
    Project.where(:id => (shared_project_ids + created_project_ids))
  end

  # All user boards
  def boards
    Board.where(:id => (shared_board_ids + branched_board_ids))
  end

  # All user memberships
  def memberships
    Membership.where(:id => (created_membership_ids + accepted_membership_ids))
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

  private

  def notify_invitation_creator
    if invitation = Invitation.find_by(:email => self.email)
      UserMailer.delay.invitation_claimed(invitation, self)
    end
  end

  # Create a job to send the confirmation email on validation
  def send_confirmation_email
    _data = previous_changes[:data]
    # It's either a hash or an array of changes
    _data = _data.last if _data.respond_to?(:last)

    if !_data.blank? and data[:confirmed].to_i > 0
      UserMailer.delay.confirmed(self)
    end
  end

end
