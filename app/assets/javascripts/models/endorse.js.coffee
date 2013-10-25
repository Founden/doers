Doers.Endorse = DS.Model.extend
  updatedAt: DS.attr('date', readOnly: true)

  user: DS.belongsTo('user', readOnly: true)
  project: DS.belongsTo('project')
  board: DS.belongsTo('board')
  topic: DS.belongsTo('topic')
  card: DS.belongsTo('card', inverse: 'endorses')
