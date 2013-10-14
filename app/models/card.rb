# DOERS [Board] [Card] class
class Card < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Available card styles
  STYLES = %w(small medium large)

  # Default scope: order by position
  default_scope { order(:position) }

  # Store accessors definition
  store_accessor :data, :alignment

  # Relationships
  belongs_to :user
  belongs_to :board
  belongs_to :project
  belongs_to :topic
  has_many :activities
  has_many :comments, :dependent => :destroy
  has_many :endorses, :dependent => :destroy

  # Validations
  validates_presence_of :user, :project, :board, :topic
  validates_inclusion_of :style, :in => STYLES
  validates_numericality_of :position

  # Scopes
  scope :aligned, proc {
    where('data @> hstore(?, ?)', 'alignment', 'true')
  }

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
  after_commit :generate_activity
end
