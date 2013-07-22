Doers.Asset = DS.Model.extend
  description: DS.attr('string')

  board: DS.belongsTo('Doers.Board')
  project: DS.belongsTo('Doers.Project')
  user: DS.belongsTo('Doers.User', readOnly: true)

  # TODO: Materialize these polymorphic definitions
  assetableId: DS.attr('number')
  assetableType: DS.attr('string')

  userNicename: DS.attr('string', readOnly: true)
  attachmentUrl: DS.attr('string', readOnly: true)
