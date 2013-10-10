Doers.ListItemsTransform = DS.Transform.extend
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
