Doers.PhotoMixin = Ember.Mixin.create
  image: DS.belongsTo('Doers.Asset', readOnly: true)
  attachment: null
  attachmentDescription: null

Doers.Photo = Doers.Card.extend(Doers.PhotoMixin)
