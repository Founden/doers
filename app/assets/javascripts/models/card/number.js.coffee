Doers.NumberMixin = Ember.Mixin.create
  content: DS.attr('number')

Doers.Number = Doers.Card.extend(Doers.NumberMixin)
