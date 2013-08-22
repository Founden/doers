# DOERS [Board] [Card] class
class Card < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Available card styles
  STYLES = %w(small medium large)

  # Default scope: order by position
  default_scope { order(:position) }

  # Store accessors definition
  store_accessor :data, :title_hint

  # Relationships
  belongs_to :user
  belongs_to :board
  belongs_to :project
  has_many :activities, :as => :trackable

  # Validations
  validates_presence_of :user, :board
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
    self.question = Sanitize.clean(self.question)
    self.help = Sanitize.clean(self.help)
    self.title_hint = Sanitize.clean(self.title_hint)
  end
  after_commit :generate_activity
end
