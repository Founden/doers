# DOERS list [Card] STI class
class Card::List < Card
  # Store accessors definition
  store_accessor :data, :items

  # Relationships
  belongs_to :parent_card, :class_name => Card::List
  has_many(:versions, :class_name => Card::List,
           :dependent => :destroy, :foreign_key => :parent_card_id)

  # Validations
  validates_presence_of :content

  # Callbacks
  # Sanitize user input
  after_initialize do
    self.items ||= []
  end
  before_validation do
    self.items = [] unless self.items.is_a?(Array)
    self.items = self.items.each_with_index do |item, index|
      if item.is_a?(Hash) and label = Sanitize.clean(item['label'])
        item['label'] = label
        item['checked'] = !!item['checked']
      end
    end
    self.items.reject!{ |item| !item.is_a?(Hash) }
  end
  # Custom serialization hooks to avoid double `to_s` since we are using hstore
  after_save :decode_items
  before_save :encode_items
  after_find :decode_items

  private

    # Callback to decode `items` from a JSON string
    def decode_items
      if self.items.is_a?(String)
        self.items = ActiveSupport::JSON.decode(self.items) rescue self.items
      end
    end

    # Callback to encode `items` to a JSON
    def encode_items
      self.items =
        ActiveSupport::JSON.encode(self.items) rescue self.items.to_json
    end
end
