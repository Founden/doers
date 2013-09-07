Doers.Comment = DS.Model.extend
  content: DS.attr('string')
  externalAuthorName: DS.attr('string', readOnly: true)
  updatedAt: DS.attr('date')

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'comments')
  project: DS.belongsTo('Doers.Project', readOnly: true, inverse: 'comments')
  board: DS.belongsTo('Doers.Board', readOnly: true, inverse: 'comments')
  card: DS.belongsTo('Doers.Card', readOnly: true, inverse: 'comments')
  parentComment: DS.belongsTo('Doers.Comment', readOnly: true, inverse: 'comments')
  comments: DS.hasMany('Doers.Comment', readOnly: true, inverse: 'parentComment')

  commentableId: DS.attr('number')
  commentableType: DS.attr('string', defaultValue: 'Card')
