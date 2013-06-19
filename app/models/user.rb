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

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :boards
  has_many :fields
  has_many :comments, :dependent => :destroy

  # Validations
  validates :email, :uniqueness => true, :presence => true
  validates_inclusion_of :interest, :in => INTERESTS.values, :allow_nil => true

  # Callbacks
  after_commit :send_welcome_email, :on => :create
  after_save :send_confirmation_email

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
    if !changes.blank? and changes[:confirmed]
      SuckerPunch::Queue.new(:email).async.perform(:confirmed, self.id)
    end
  end

end
