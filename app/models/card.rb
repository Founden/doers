# DOERS [Board] [Card] class
class Card < ActiveRecord::Base
  # Available card styles
  STYLES = %w(small medium large)

  # Default scope: order by position
  default_scope { order(:position) }

  # Relationships
  belongs_to :user
  belongs_to :board
  belongs_to :project

  # Validations
  validates_presence_of :title, :user, :board
  validates_inclusion_of :style, :in => STYLES
  validates_numericality_of :position

  # Callbacks
  after_initialize do
    self.position ||= 0
    self.style ||= STYLES.first
  end
  # Sanitize user input
  before_validation do
    self.title = Sanitize.clean(self.title)
    self.content = Sanitize.clean(self.content) if self.content.is_a?(String)
  end

end
