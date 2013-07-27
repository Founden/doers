Ember.Handlebars.helper 'website', (value) ->
  if value
    value.match('https?://(.*[^/])')[1]
