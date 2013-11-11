# [Membership] model serializer
class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :notify_discussions, :notify_collaborations
  attributes :notify_boards_topics, :notify_cards_alignments

  has_one :creator, :embed => :id
  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_one :project, :embed => :id


  # Method to use for aliasing what attributes can be included
  def is_current_user?
    current_account.id.eql?(object.user.id)
  end
  alias_method :include_notify_discussions?, :is_current_user?
  alias_method :include_notify_collaborations?, :is_current_user?
  alias_method :include_notify_boards_topics?, :is_current_user?
  alias_method :include_notify_cards_alignments?, :is_current_user?
end
