Doers.ListMixin = Ember.Mixin.create
  items: DS.attr(
    'list_items', defaultValue: Ember.ArrayProxy.create(content: []))

  didLoad: ->
    @get('items').contentArrayDidChange = =>
      @send('becomeDirty')

Doers.List = Doers.Card.extend(Doers.ListMixin)
