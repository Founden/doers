Doers.TimestampMixin = Ember.Mixin.create
  content: DS.attr('date')
  timestamp: DS.attr('string', readOnly: true)

Doers.Timestamp = Doers.Card.extend(Doers.TimestampMixin)
