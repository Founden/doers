Ember.Handlebars.helper 'website', (value) ->
  if value and (match = value.match('https?://(.*[^/])'))
    match[1]

Ember.Handlebars.helper 'www_domain', (value) ->
  if value and (match = value.match('https?://([a-z\-.]+)'))
    match[1]
