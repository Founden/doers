Doers.MapMixin = Ember.Mixin.create
  location: DS.attr('string')
  address: DS.attr('string')
  latitude: DS.attr('number')
  longitude: DS.attr('number')

Doers.Map = Doers.Card.extend(Doers.MapMixin)
