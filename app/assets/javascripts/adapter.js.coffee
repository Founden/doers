Doers.RESTAdapter = DS.RESTAdapter.extend
  bulkCommit: false
  # API End-point namespace
  namespace: 'api/v1'
  serializer: Doers.RESTSerializer

Doers.RESTAdapter.registerTransform 'list_items',
  serialize: (list) ->
    items = []
    list.forEach (item) ->
      items.push item.getProperties('label', 'checked')
    items

  deserialize: (items) ->
    list = Ember.ArrayController.create()
    if Ember.isArray(items)
      items.forEach (item) ->
        list.addObject Ember.Object.create(item)
    list
