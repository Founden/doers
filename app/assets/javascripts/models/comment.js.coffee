Doers.Comment = DS.Model.extend
  content: DS.attr('string')
  parentComment: DS.belongsTo('Doers.Comment', inverse: 'comments')
  updatedAt: DS.attr('date')

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'comments')
  project: DS.belongsTo('Doers.Project', inverse: 'comments')
  board: DS.belongsTo('Doers.Board', inverse: 'comments')
  card: DS.belongsTo('Doers.Card', readOnly: true, inverse: 'comments')
  externalAuthorName: DS.attr('string', readOnly: true)
  comments: DS.hasMany('Doers.Comment', readOnly: true, inverse: 'parentComment')

  commentableId: DS.attr('number')
  commentableType: DS.attr('string', defaultValue: 'Card')
