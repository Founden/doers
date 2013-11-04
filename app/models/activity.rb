# DOERS [Activity] class
class Activity < ActiveRecord::Base
  # Include [Activity] notifications
  include Activity::Notifier

  # Some dynamic attributes
  store_accessor :data, :user_name, :project_title, :board_title
  store_accessor :data, :card_title, :topic_title, :invitation_email

  # Default scope: order by last update
  default_scope { order(:updated_at => :desc) }

  # Relationships
  belongs_to :project
  belongs_to :board
  belongs_to :whiteboard
  belongs_to :user
  belongs_to :card
  belongs_to :topic
  belongs_to :comment

  # Validations
  validates_presence_of :user
  validates_presence_of :slug

  # Callbacks
  after_validation do
    self.user_name = self.user.nicename if self.user
    self.project_title = self.project.title if self.project
    self.board_title = self.board.title if self.board
    self.topic_title = self.topic.title if self.topic
    self.card_title = self.card.title if self.card
  end
end
