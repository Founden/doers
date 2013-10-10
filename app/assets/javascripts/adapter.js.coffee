Doers.ApplicationAdapter = DS.ActiveModelAdapter.extend
  # API End-point namespace
  namespace: 'api/v1'
  defaultSerializer: 'application'
  pathForType: (type) ->
    decamelized = Ember.String.decamelize(type)
    if decamelized in ['photo', 'paragraph', 'map', 'link']
      decamelized = 'card'
    Ember.String.pluralize(decamelized)
