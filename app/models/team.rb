# Doers [User] Team class
class Team < ActiveRecord::Base
  store_accessor :data, :website, :angeli_list

  # Relationships
  has_many :boards
  has_many :users, :through => :boards
  has_one(:banner, :as => :assetable,
          :class_name => Asset::Banner, :dependent => :destroy)

  # Validations
  validates_presence_of :title, :slug
  validates_uniqueness_of :slug

  # Callbacks
  before_validation do
    # Sanitize user input
    self.title = Sanitize.clean(self.title)
    self.description = Sanitize.clean(self.description)
    self.slug = (Sanitize.clean(self.slug) || self.title).parameterize
  end
end
