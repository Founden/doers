Doers.TimestampMixin = Ember.Mixin.create
  timestamp: DS.attr('date')
  parsedTimestamp: DS.attr('string')

Doers.Timestamp = Doers.Card.extend(Doers.TimestampMixin)
