Doers.PhotoMixin = Ember.Mixin.create
  imageUrl: DS.attr('string')

  asset: DS.belongsTo('Doers.Asset')

Doers.Photo = Doers.Card.extend(Doers.PhotoMixin)
