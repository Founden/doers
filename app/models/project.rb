# DOERS [Project] class
class Project < ActiveRecord::Base
  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # TODO: Change this to an hstore when in production
  store :data, :coder => JSON
  store_accessor :data, :angel_list_id, :website

  # Relationships
  belongs_to :user
  has_many :personas, :class_name => Board::Persona
  has_many :problems, :class_name => Board::Problem
  has_many :solutions, :class_name => Board::Solution
  has_many :fields
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
end
