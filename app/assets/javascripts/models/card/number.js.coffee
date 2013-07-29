Doers.NumberMixin = Ember.Mixin.create
  content: DS.attr('string')
  number: DS.attr('number')

Doers.Number = Doers.Card.extend(Doers.NumberMixin)
