Doers.IntervalMixin = Ember.Mixin.create
  minimum: DS.attr('number')
  maximum: DS.attr('number')
  selected: DS.attr('number')

  progress: ( ->
    min = @get('minimum')
    max = @get('maximum')
    value = @get('selected')
    Math.floor((value - min) / (max - min) * 100)
  ).property('minimum', 'maximum', 'selected')

Doers.Interval = Doers.Card.extend(Doers.IntervalMixin)
