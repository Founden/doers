Doers.Asset = DS.Model.extend
  description: DS.attr('string')
  attachment: DS.attr('string')
  type: DS.attr('string')

  board: DS.belongsTo('board')
  project: DS.belongsTo('project')
  user: DS.belongsTo('user', readOnly: true)

  # TODO: Materialize these polymorphic definitions
  assetableId: DS.attr('number')
  assetableType: DS.attr('string')

  # Attachment size URLs
  thumbSizeUrl: DS.attr('string', readOnly: true)
  smallSizeUrl: DS.attr('string', readOnly: true)
  mediumSizeUrl: DS.attr('string', readOnly: true)
