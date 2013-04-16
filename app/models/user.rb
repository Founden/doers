# DOERS [User] class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  # Relationships
  has_many :projects, :dependent => :destroy
  has_many :panels
  has_many :boards
  has_many :fields

  # Validations
  validates :email, :uniqueness => true, :presence => true

  # Helper to generate the user name
  def nicename
    name || email
  end
end
