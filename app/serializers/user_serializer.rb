# [User] model serializer
class UserSerializer < ActiveModel::Serializer
  include GravatarHelper

  attributes :id, :nicename, :external_id, :angel_list_token
  attributes :avatar_url, :admin? => :is_admin, :importing => :isImporting

  # Angel List access token from available identities
  def angel_list_token
    identity = object.identities.first
    identity.token if identity.respond_to?(:token)
  end

  # Generates user avatar URL
  def avatar_url
    gravatar_uri(object.email)
  end
end
