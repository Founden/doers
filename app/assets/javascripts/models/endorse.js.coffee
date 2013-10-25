Doers.Endorse = DS.Model.extend
  updatedAt: DS.attr('date', readOnly: true)

  user: DS.belongsTo('user', readOnly: true, inverse: 'endorses')
  project: DS.belongsTo('project', inverse: 'endorses')
  board: DS.belongsTo('board', inverse: 'endorses')
  topic: DS.belongsTo('topic', inverse: 'endorses')
  card: DS.belongsTo('card', inverse: 'endorses')
