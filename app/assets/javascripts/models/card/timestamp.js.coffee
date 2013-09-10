Doers.TimestampMixin = Ember.Mixin.create
  content: DS.attr('string')
  timestamp: null
  dateString: null
  timeString: null
  timestampLoaded: false
  dateFormat: 'DD MMM YYYY'
  timeFormat: 'HH:MM A'
  fullFormat: 'YYYY-MM-DD HH:mm:ss'

  didLoad: ->
    if ts = moment(@get('content'))
      @set('timestamp', ts)
      @set('dateString', ts.format(@dateFormat))
      @set('timeString', ts.format(@timeFormat))
      @timestampLoaded = true

  timestampChanged: ( ->
    if @timestampLoaded
      datetime = moment(@get('timestamp')).format(@fullFormat)
      @set('content', datetime)
  ).observes('timestamp')

  # Updates the `timestamp` object to current date-time string
  dateTimeChanged: ( ->
    if @timestampLoaded
      time = @get('timeString') || '00:00:00'
      date = @get('dateString')
      timestampString = '%@ %@'.fmt(date, time)

      if ts = moment(timestampString)
        @set('timestamp', ts)
    ).observes('dateString', 'timeString')

Doers.Timestamp = Doers.Card.extend(Doers.TimestampMixin)
