# DOERS [Activity] class
class Activity < ActiveRecord::Base
  # Some dynamic attributes
  store_accessor :data, :user_name, :project_title, :board_title
  store_accessor :data, :trackable_title, :comment_id

  # Default scope: order by last update
  default_scope { order(:updated_at) }

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :user
  belongs_to :trackable, :polymorphic => true

  # Validations
  validates_presence_of :user
  validates_presence_of :trackable_id
  validates_presence_of :trackable_type
  validates_presence_of :slug

  # Callbacks
  after_validation do
    self.user_name = self.user.nicename if self.user
    self.project_title = self.project.title if self.project
    self.board_title = self.board.title if self.board
  end
end
