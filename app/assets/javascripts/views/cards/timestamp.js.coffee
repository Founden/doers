Doers.TimestampView = Ember.View.extend
  templateName: 'cards/timestamp'
  safeTimestamp: (->
    if timestamp = @get('content.timestamp')
      timestamp.toString()
  ).property('content.timestamp')
