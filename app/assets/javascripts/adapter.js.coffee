Doers.ApplicationAdapter = DS.ActiveModelAdapter.extend
  # API End-point namespace
  namespace: 'api/v1'
  defaultSerializer: 'application'

  # Make sure we send requests to parent type API endpoint
  # TODO: Make this smarter
  pathForType: (type) ->
    decamelized = Ember.String.decamelize(type)
    if decamelized in ['photo', 'paragraph', 'map', 'link']
      decamelized = 'card'
    if decamelized in ['logo', 'image', 'banner', 'cover']
      decamelized = 'asset'
    Ember.String.pluralize(decamelized)
