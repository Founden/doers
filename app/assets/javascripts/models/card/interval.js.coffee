Doers.IntervalMixin = Ember.Mixin.create
  minimum: DS.attr('number')
  maximum: DS.attr('number')
  selected: DS.attr('number')

Doers.Interval = Doers.Card.extend(Doers.IntervalMixin)
