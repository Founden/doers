Doers.TimestampMixin = Ember.Mixin.create
  content: DS.attr('string')
  timestamp: null
  dateString: null
  timeString: null
  timestampLoaded: false
  dateFormat: 'DD-MM-YYYY'
  timeFormat: 'HH:mm:ss'

  didLoad: ->
    if ts = new Date(@get('content'))
      @set('timestamp', ts)
      @set('dateString', moment(ts).format(@dateFormat))
      @set('timeString', moment(ts).format(@timeFormat))
      @timestampLoaded = true

  timestampChanged: ( ->
    if @timestampLoaded
      @set('content', @get('timestamp').toString())
  ).observes('timestamp')

  # Updates the `timestamp` object to current date-time string
  dateTimeChanged: ( ->
    if @timestampLoaded
      time = @get('timeString') || '00:00:00'
      date = @get('dateString')
      timestampString = '%@ %@'.fmt(time, date)

      if ts = new Date(timestampString)
        @set('timestamp', ts)
    ).observes('dateString', 'timeString')

Doers.Timestamp = Doers.Card.extend(Doers.TimestampMixin)
