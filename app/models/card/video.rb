# DOERS video [Card] model
class Card::Video < Card
  PROVIDERS = %w(youtube)

  # Relationships
  has_one :image, :dependent => :destroy, :as => :assetable

  # Store accessors definition
  store_accessor :data, :video_id, :provider

  # Validations
  validates_presence_of :video_id, :provider
  validates_inclusion_of :provider, :in => PROVIDERS
end
