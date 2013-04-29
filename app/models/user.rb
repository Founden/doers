# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :panels
  has_many :boards
  has_many :fields

  has_many(:oauth_applications, :class_name => 'Doorkeeper::Application',
           :as => :owner, :dependent => :destroy)
  has_many(:access_tokens, :class_name => 'Doorkeeper::AccessToken',
           :foreign_key => :resource_owner_id, :dependent => :destroy)

  # Validations
  validates :email, :uniqueness => true, :presence => true

  # Callbacks
  after_create :create_access_token

  # Creates an access token for current user if there's a pre-defined webapp uid
  def create_access_token
    app = Doorkeeper::Application.where(:uid => Doers::Config.webapp_uid).first
    app.authorized_tokens.create(:resource_owner_id => self.id) unless app.nil?
  end


  # Helper to generate the user name
  def nicename
    name || email
  end
end
