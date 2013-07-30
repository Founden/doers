Ember.Handlebars.helper 'timeago', (value) ->
  moment(value).fromNow()

Ember.Handlebars.helper 'datetime', (value, options) ->
  format = options.format || 'MMMM Do YYYY, h:mm:ss'
  moment(value).format(format)

Ember.Handlebars.helper 'date', (value, options) ->
  format = options.format || 'MMMM Do YYYY'
  moment(value).format(format)

Ember.Handlebars.helper 'time', (value, options) ->
  format = options.format || 'hh:mm:ss'
  moment(value).format(format)
