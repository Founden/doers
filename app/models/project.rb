# DOERS [Project] class
class Project < ActiveRecord::Base
  # Include [Activity] generations support
  include Activity::Support

  # Available :status values for a [Project]
  STATES = ['private', 'public', 'archived']

  # Relationships
  belongs_to :user
  has_many :boards
  has_many :cards, :through => :boards
  has_many :comments, :dependent => :destroy
  has_one :logo, :dependent => :destroy, :class_name => Asset::Logo
  has_many :activities
  has_many :members, :through => :memberships, :source => :user
  has_many :owners, :through => :owner_memberships, :source => :user
  has_many :invitations, :dependent => :destroy, :as => :invitable
  has_many(
    :memberships, :dependent => :destroy, :class_name => ProjectMembership)
  has_many(
    :owner_memberships, :dependent => :destroy, :class_name => OwnerMembership)
  has_many :topics
  has_many(:collaborations, :class_name => Membership)
  has_many(:collaborators, :through => :collaborations, :source => :user)
  has_many :endorses, :dependent => :destroy

  # Validations
  validates :user, :presence => true
  validates :title, :presence => true
  validates :status, :inclusion => {:in => STATES}
  validates_format_of(
    :website, :with => URI::regexp(%w(http https)), :allow_blank => true)
  validates :external_id,
    :uniqueness => {:scope => [:external_type, :user_id]}, :allow_nil => true
  validates_inclusion_of :external_type,
    :in => Doers::Config.external_types, :if => :external_id

  # Callbacks
  after_initialize do
    self.status ||= STATES.first
  end
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
  end
  after_commit :generate_activity
  after_create do
    self.owner_memberships.create(:creator => self.user, :user => self.user)
  end
end
