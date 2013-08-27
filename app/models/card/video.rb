# DOERS video [Card] model
class Card::Video < Card
  PROVIDERS = %w(youtube)

  # Relationships
  has_one(:image, :dependent => :destroy,
          :as => :assetable, :class_name => Asset::Image)
  belongs_to :parent_card, :class_name => Card::Video
  has_many(:versions, :class_name => Card::Video,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Store accessors definition
  store_accessor :data, :video_id, :provider

  # Validations
  validates_presence_of :video_id, :provider
  validates_inclusion_of :provider, :in => PROVIDERS
end
