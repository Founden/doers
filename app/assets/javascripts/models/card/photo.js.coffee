Doers.PhotoMixin = Ember.Mixin.create
  image: DS.belongsTo('Doers.Asset', readOnly: true)

Doers.Photo = Doers.Card.extend(Doers.PhotoMixin)
