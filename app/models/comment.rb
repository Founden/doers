# DOERS [Comment] class
class Comment < ActiveRecord::Base
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
end
