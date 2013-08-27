Doers.RESTAdapter = DS.RESTAdapter.extend
  bulkCommit: false
  # API End-point namespace
  namespace: 'api/v1'
  serializer: Doers.RESTSerializer

Doers.RESTAdapter.configure('plurals', {activity: 'activities'})

Doers.RESTAdapter.registerTransform 'list_items',
  listItemClass: Ember.Object.extend
    list: null
    label: null
    checked: null
    itemChanged: ( ->
      if list = @get('list')
        list.contentArrayDidChange()
    ).observes('label', 'checked')

  serialize: (list) ->
    items = []
    list.forEach (item) ->
      items.push item.getProperties('label', 'checked')
    items

  deserialize: (items) ->
    list = Ember.ArrayProxy.create(content: [])
    if Ember.isArray(items)
      items.forEach (item) =>
        listItem = @listItemClass.create(item)
        listItem.set('list', list)
        list.addObject listItem
    list

Doers.RESTAdapter.registerTransform 'array',
  serialize: (value) ->
    if Ember.typeOf(value) == 'array'
      value
    else
      []

  deserialize: (array) ->
    array
