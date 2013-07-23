Doers.VideoMixin = Ember.Mixin.create
  videoId: DS.attr('string')
  provider: DS.attr('string')
  image: DS.belongsTo('Doers.Asset', readOnly: true)

Doers.Video = Doers.Card.extend(Doers.VideoMixin)
