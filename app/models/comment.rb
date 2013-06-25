# DOERS [Comment] class
class Comment < ActiveRecord::Base
  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON
  store_accessor :data, :angel_list_id
  store_accessor :data, :angel_list_author_name, :angel_list_author_id

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :user
  belongs_to :parent_comment, :class_name => Comment
  has_many :comments, :foreign_key => :parent_comment_id, :dependent => :destroy

  # Validations
  validates :content, :presence => true

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Sanitize.clean(self.content)
  end

  # Handles user name in case the comment was imported
  # @return OpenStruct to mock user fields
  def author
    user || OpenStruct.new({
      :nicename => angel_list_author_name,
      :email => "%s@%s" % [angel_list_author_id, Doers::Config.app_id]
    })
  end

  # Flags if the comment was imported
  def imported?
    !angel_list_id.blank?
  end
end
