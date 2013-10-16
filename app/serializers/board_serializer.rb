# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description, :card_ids
  attributes :branches_count, :topics_count, :last_update, :collections
  attributes :progress

  has_one :user, :embed => :id
  has_one :author, :embed => :id
  has_one :project, :embed => :id
  has_one :parent_board, :embed => :id
  has_one :cover, :embed => :id
  has_one :team, :embed => :id

  has_many :branches, :embed => :ids
  has_many :cards, :embed => :ids
  has_many :activities, :embed => :id
  has_many :memberships, :embed => :id
  has_many :topics, :embed => :id
  has_many :parent_board_topics, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # Returns how many times this was branched
  def branches_count
    object.branches.count
  end

  # Returns the number of topics
  def topics_count
    object.parent_board_topics.count
  end

  # Returns collection/tag names
  def collections
    object.tags.pluck('name').map(&:titleize)
  end

  # TODO: Move this to the model
  def progress
    completed_count = object.cards.aligned.count
    topics_count > 0 ? (( completed_count.to_f / topics_count) * 100).to_i : 100
  end

  # Helper to alias to when its a whiteboard
  def is_whiteboard?
    object.parent_board_id.blank?
  end

  # Helper to alias to when its NOT a whiteboard
  def is_not_whiteboard?
    !object.parent_board_id.blank?
  end

  alias_method :include_collections?, :is_whiteboard?
  alias_method :include_topics?, :is_whiteboard?
  alias_method :include_progress?, :is_not_whiteboard?
  alias_method :include_parent_board_topics?, :is_not_whiteboard?
end
