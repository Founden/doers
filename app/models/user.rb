# DOERS user class
class User < ActiveRecord::Base
  # Include support for authentication
  include EasyAuth::Models::Account

  # Validations
  validates :email, :uniqueness => true, :presence => true
end
