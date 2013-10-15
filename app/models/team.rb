# Doers [User] Team class
class Team < ActiveRecord::Base
  # List of allowed URI schemes
  ALLOWED_SCHEMES = %w(http https)

  store_accessor :data, :website, :angel_list

  # Relationships
  has_many :whiteboards
  has_many :users, :through => :whiteboards
  has_one(:banner, :as => :assetable,
          :class_name => Asset::Banner, :dependent => :destroy)

  # Validations
  validates_presence_of :title, :slug
  validates_uniqueness_of :slug
  validates_format_of :website, :with => URI.regexp(ALLOWED_SCHEMES)
  validates_format_of :angel_list, :with => URI.regexp(ALLOWED_SCHEMES)

  # Callbacks
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
    self.slug = (Sanitize.clean(self.slug) || self.title).to_s.parameterize
  end
end
