# Password identity class
class Identities::Password < Identity
  include EasyAuth::Models::Identities::Password

  # Authenticates using password token name
  def self.authenticate(controller, token_name = :password)
    super
  end
end
