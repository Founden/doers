Doers.ListMixin = Ember.Mixin.create
  items: DS.attr('list_items')

  didLoad: ->
    @get('items').contentArrayDidChange = =>
      @send('becomeDirty')

Doers.List = Doers.Card.extend(Doers.ListMixin)
