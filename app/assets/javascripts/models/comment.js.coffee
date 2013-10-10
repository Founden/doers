Doers.Comment = DS.Model.extend
  content: DS.attr('string')
  updatedAt: DS.attr('date')
  externalAuthorName: DS.attr('string', readOnly: true)

  parentComment: DS.belongsTo('comment', inverse: 'comments')
  user: DS.belongsTo('user', readOnly: true)
  project: DS.belongsTo('project')
  board: DS.belongsTo('board')
  card: DS.belongsTo('card', readOnly: true, inverse: 'comments')
  topic: DS.belongsTo('topic', readOnly: true, inverse: 'comments')
  comments: DS.hasMany('comment', readOnly: true, inverse: 'parentComment', async: true)
