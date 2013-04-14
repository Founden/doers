# DOERS text area [Field] STI class
class Field::TextArea < Field
  # Store accessors definition
  store_accessor :data, :content

  # Validations
  validates_presence_of :content

  # Callbacks
  # Sanitize user input
  before_validation do
    self.content = Sanitize.clean(self.content, Sanitize::Config::BASIC)
  end
end
