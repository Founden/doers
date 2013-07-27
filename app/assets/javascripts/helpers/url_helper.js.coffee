Ember.Handlebars.helper 'website', (value, option) ->
  if value
    value.match('https?://(.*[^/])')[1]
