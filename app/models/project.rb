# DOERS [Project] class
class Project < ActiveRecord::Base
  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # Relationships
  belongs_to :user
  has_many :boards
  has_many :cards, :through => :boards
  has_many :comments, :dependent => :destroy
  has_one :logo, :dependent => :destroy

  # Validations
  validates :user, :presence => true
  validates :title, :presence => true
  validates :status, :inclusion => {:in => STATES}
  validates_format_of(
    :website, :with => URI::regexp(%w(http https)), :allow_blank => true)
  validates :external_id, :uniqueness => {:scope => :external_type}
  validates_inclusion_of :external_type, :in => Doers::Config.external_types

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
end
