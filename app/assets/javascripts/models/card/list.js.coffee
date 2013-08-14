Doers.ListMixin = Ember.Mixin.create
  items: DS.attr('list_items')

  didLoad: ->
    @set('items', Ember.ArrayProxy.create(content: [])) unless @get('items')
    @get('items').contentArrayDidChange = =>
      @send('becomeDirty')

Doers.List = Doers.Card.extend(Doers.ListMixin)
