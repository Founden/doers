Doers.MapMixin = Ember.Mixin.create
  latitude: DS.attr('number')
  longitude: DS.attr('number')

Doers.Map = Doers.Card.extend(Doers.MapMixin)
