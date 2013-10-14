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

  # Tweak findMany for topic requests to include its board
  findMany: (store, type, ids, owner) ->
    if @container.resolve('model:topic').detect(type)
      @ajax @buildURL(type.typeKey), 'GET', data:
        ids: ids, board_id: owner.get('id')
    else
      @_super(store, type, ids, owner)
