# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON
  store_accessor :data, :angel_list_id

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :boards
  has_many :fields
  has_many :comments, :dependent => :destroy

  # Validations
  validates :email, :uniqueness => true, :presence => true

  # Helper to generate the user name
  def nicename
    name || email
  end
end
