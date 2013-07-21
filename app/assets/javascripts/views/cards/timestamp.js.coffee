Doers.TimestampView = Ember.View.extend
  templateName: 'cards/timestamp'
  safeTimestamp: (->
    @get('content.timestamp').toString()
  ).property('content.timestamp')
