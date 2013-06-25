# DOERS options [Card] STI class
#
# @example `#data` will represent a JSON like below
#   {
#     "title": "Some Title",
#     "options": [
#       0: {
#         "label": "Some Text",
#         "selected": false
#       },
#       1: {
#         "label": "Another Text",
#         "selected": true
#       }
#     ]
#   }
#
class Card::Options < Card
  # Store accessors definition
  store_accessor :data, :options

  # Validations
  validates_presence_of :options

  # Callbacks
  # Sanitize user input
  before_validation do
    unless self.options.nil?
      self.options.collect! do |option|
        option.delete_if { |k, v| v.blank? } if !option.nil?

        option['label'] = Sanitize.clean(option['label'])
        option['selected'] = option['selected'] ? true : false
        option if !option['label'].blank?
      end
      self.options.compact!
    end
  end

  # Check if there are available options
  # @return [Boolean]
  def has_options?
    puts self.options.to_s
    !self.options.nil? and !self.options.empty?
  end
end
