# DOERS list [Card] STI class
class Card::List < Card
  # Store accessors definition
  store_accessor :data, :items
  # Serialize items into an array
  serialize :items, ActiveSupport::JSON

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
end
