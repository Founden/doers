# DOERS [Comment] class
class Comment < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  store_accessor :data, :external_id, :external_type
  store_accessor :data, :external_author_name, :external_author_id

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :user
  belongs_to :parent_comment, :class_name => Comment
  belongs_to :card
  belongs_to :topic
  has_many :comments, :foreign_key => :parent_comment_id, :dependent => :destroy
  belongs_to :topic

  # Validations
  validates_presence_of :content
  validates_inclusion_of(
    :external_type, :in => Doers::Config.external_types, :if => :external?)

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Sanitize.clean(self.content)
  end
  after_commit(
    :generate_activity, :on => [:create], :unless => :parent_comment_id)

  # Handles user name in case the comment was imported
  # @return OpenStruct to mock user fields
  def author
    user || OpenStruct.new({
      :nicename => external_author_name,
      :email => "%s@%s" % [external_author_id, Doers::Config.app_id]
    })
  end

  # Flags if the comment was imported
  def external?
    !external_id.blank?
  end

  # Target to use when generating activities
  def activity_owner
    self.topic || self.board || self.project
  end
end
