# [User] model serializer
class UserSerializer < ActiveModel::Serializer
  include GravatarHelper

  attributes :id, :nicename, :external_id, :angel_list_token
  attributes :avatar_url, :admin? => :is_admin, :importing => :is_importing
  attributes :public_board_ids

  has_many :projects, :embed => :id
  has_many :authored_boards, :embed => :id
  has_many :boards, :embed => :id

  # Returns available public boards
  def public_board_ids
    Board.public.pluck('id')
  end

  # Angel List access token from available identities
  def angel_list_token
    identity = object.identities.first
    identity.token if identity.respond_to?(:token)
  end

  # Generates user avatar URL
  def avatar_url
    gravatar_uri(object.email)
  end

  # Method to use for aliasing what attribtues can be included
  def is_current_user?
    current_account.id.eql?(object.id)
  end
  alias_method :include_external_id?, :is_current_user?
  alias_method :include_angel_list_token?, :is_current_user?
  alias_method :include_projects?, :is_current_user?
  alias_method :include_authored_boards?, :is_current_user?
  alias_method :include_public_board_ids?, :is_current_user?
  alias_method :include_boards?, :is_current_user?
end
