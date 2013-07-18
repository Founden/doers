Doers.VideoMixin = Ember.Mixin.create
  videoId: DS.attr('string')
  provider: DS.attr('string')
  imageUrl: DS.attr('string', readOnly: true)

  asset: DS.belongsTo('Doers.Asset')

Doers.Video = Doers.Card.extend(Doers.VideoMixin)
