Doers.ArrayTransform = DS.Transform.extend
  serialize: (value) ->
    if Ember.typeOf(value) == 'array'
      value
    else
      []

  deserialize: (array) ->
    array
