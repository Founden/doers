Doers.TimestampView = Ember.View.extend Doers.CardViewMixin,
  templateName: 'cards/timestamp'
  safeTimestamp: (->
    if timestamp = @get('content.content')
      timestamp.toString()
  ).property('content.content')
