Ember.Handlebars.helper 'website', (value) ->
  if value and (match = value.match('https?://(.*[^/])'))
    match[1]
