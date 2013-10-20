Doers.Endorse = Doers.Activity.extend
  project: DS.belongsTo('project', inverse: 'endorses')
  board: DS.belongsTo('board', inverse: 'endorses')
  topic: DS.belongsTo('topic', inverse: 'endorses')
  card: DS.belongsTo('card', inverse: 'endorses')
