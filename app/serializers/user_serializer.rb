# [User] model serializer
class UserSerializer < ActiveModel::Serializer
  attributes :id, :nicename, :external_id, :angel_list_token, :importing

  # Angel List access token from available identities
  def angel_list_token
    identity = object.identities.first
    identity.token if identity.respond_to?(:token)
  end
end
