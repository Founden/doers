# [Membership] model serializer
class MembershipSerializer < ActiveModel::Serializer
  attributes :id, :updated_at

  has_one :creator, :embed => :id
  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_one :project, :embed => :id
end
