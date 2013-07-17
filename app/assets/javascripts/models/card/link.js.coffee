Doers.LinkMixin = Ember.Mixin.create
  url: DS.attr('string')
  excerpt: DS.attr('string')

Doers.Link = Doers.Card.extend(Doers.LinkMixin)
