# DOERS numeric [Field] STI class
class Field::Numerics < Field
  # Store accessors definition
  store_accessor :data, :title, :minimum, :maximum, :selected

  # Validations
  validates_presence_of :title, :minimum, :maximum, :selected
  validates_numericality_of :minimum, :maximum, :selected

  # Callbacks
  # Sanitize user input
  before_validation do
    self.title = Sanitize.clean(self.title)
    return false if (self.minimum.to_i > self.maximum.to_i) or
      (self.maximum.to_i < self.minimum.to_i) or
      (self.selected.to_i > self.maximum.to_i or
       self.selected.to_i < self.minimum.to_i)
  end
end
