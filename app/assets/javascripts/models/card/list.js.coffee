Doers.ListMixin = Ember.Mixin.create
  items: DS.attr('list_items')

Doers.List = Doers.Card.extend(Doers.ListMixin)
