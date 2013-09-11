Doers.Comment = DS.Model.extend
  content: DS.attr('string')
  parentComment: DS.belongsTo('Doers.Comment', inverse: 'comments')
  updatedAt: DS.attr('date')

  user: DS.belongsTo('Doers.User', readOnly: true)
  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')
  card: DS.belongsTo('Doers.Card', readOnly: true)
  externalAuthorName: DS.attr('string', readOnly: true)
  comments: DS.hasMany('Doers.Comment', readOnly: true, inverse: 'parentComment')

  commentableId: DS.attr('number')
  commentableType: DS.attr('string', defaultValue: 'Card')
