# DOERS [Project] class
class Project < ActiveRecord::Base
  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON
  store_accessor :data, :angel_list_id, :website

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
