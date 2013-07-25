# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  INTERESTS = {
    _('Founder') => 'founder',
    _('Advisor') => 'advisor',
    _('Domain Expert') => 'expert',
    _('Running an Accelerator') => 'owner'
  }

  store_accessor :data, :confirmed, :interest, :company
  store_accessor :data, :importing, :newsletter_allowed

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :boards
  has_many :cards
  has_many :comments, :dependent => :destroy
  has_many :assets, :dependent => :destroy
  has_many :images

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  after_commit :send_confirmation_email, :on => :update

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

  # All available boards, including public and from shared projects
  def all_boards
    t = Board.arel_table
    Board.where(
      # Created or branched from
      t[:author_id].eq(id).or(t[:user_id].eq(id)).or(
        # Part of available projects
        t[:project_id].in(project_ids)
      ).or(
        # Status is `public`
        t[:status].eq(Board::STATES.last)
      )
    )
  end

  private

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
