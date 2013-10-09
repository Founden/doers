Doers.Asset = DS.Model.extend
  description: DS.attr('string')
  attachment: DS.attr('string')
  type: DS.attr('string')

  board: DS.belongsTo('Doers.Board')
  project: DS.belongsTo('Doers.Project')
  user: DS.belongsTo('Doers.User', readOnly: true)

  # TODO: Materialize these polymorphic definitions
  assetableId: DS.attr('number')
  assetableType: DS.attr('string')

  # Attachment size URLs
  thumbSizeUrl: DS.attr('string', readOnly: true)
  smallSizeUrl: DS.attr('string', readOnly: true)
  mediumSizeUrl: DS.attr('string', readOnly: true)
