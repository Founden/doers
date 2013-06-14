# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  INTERESTS = {
    _('Founder') => :founder,
    _('Advisor') => :advisor,
    _('Domain Expert') => :expert,
    _('Running an Accelerator') => :owner
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

  # Helper to generate the user name
  def nicename
    name || email
  end

  def confirmed?
    !confirmed.blank?
  end
end
