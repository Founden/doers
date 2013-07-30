Doers.TimestampMixin = Ember.Mixin.create
  content: DS.attr('string')
  timestamp: null
  dateString: null
  timeString: null
  niceDateString: null
  timestampLoaded: false

  leadingZeroesInDate: (date) ->
    '%@-%@-%@'.fmt(
      date.getFullYear(),
      ('0' + date.getMonth()).slice(-2),
      ('0' + date.getDate()).slice(-2)
    )

  didLoad: ->
    if ts = new Date(@get('content'))
      @set('timestamp', ts)
      @set('dateString', @leadingZeroesInDate(ts))
      @set('timeString', ts.toLocaleTimeString())
      @set('niceDateString', @get('timestamp').toDateString())
      @set('timestampLoaded', true)

  timestampChanged: ( ->
    if @get('timestampLoaded')
      @set('niceDateString', @get('timestamp').toDateString())
      @set('content', @get('timestamp').toString())
  ).observes('timestamp')

  # Updates the `timestamp` object to current date-time string
  dateTimeChanged: ( ->
    if @get('timestampLoaded')
      time = @get('timeString') || '00:00:00'
      date = @get('dateString')
      timestampString = '%@ %@'.fmt(time, date)

      if ts = new Date(timestampString)
        @set('timestamp', ts)
    ).observes('dateString', 'timeString')

Doers.Timestamp = Doers.Card.extend(Doers.TimestampMixin)
