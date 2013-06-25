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

  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON
  store_accessor :data, :angel_list_id, :confirmed, :interest, :company
  store_accessor :data, :importing

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :boards
  has_many :cards
  has_many :comments, :dependent => :destroy

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  after_commit :send_welcome_email, :on => :create
  after_commit :send_confirmation_email, :on => :update

  # Helper to generate the user name
  def nicename
    name || email
  end

  # Checks if user is confirmed
  def confirmed?
    !confirmed.blank?
  end

  # Check if user can administrate things
  def admin?
    !Doers::Config.admin_regex.match(email).blank?
  end

  private

  # Creates a job to send the welcome email
  def send_welcome_email
    SuckerPunch::Queue.new(:email).async.perform(:welcome, self.id)
  end

  # Create a job to send the confirmation email on validation
  def send_confirmation_email
    _data = previous_changes[:data]
    # It's either a hash or an array of changes
    _data = _data.last if _data.respond_to?(:last)

    if !_data.blank? and data[:confirmed].to_i > 0
      SuckerPunch::Queue.new(:email).async.perform(:confirmed, self.id)
    end
  end

end
