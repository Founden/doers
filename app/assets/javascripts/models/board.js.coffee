Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')

  parentBoard: DS.belongsTo('Doers.Board', {inverse: 'parentBoard'})
  project: DS.belongsTo('Doers.Project')
  user: DS.belongsTo('Doers.User', readOnly: true)
  author: DS.belongsTo('Doers.User', readOnly: true)

  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)
  userNicename: DS.attr('string', readOnly: true)
  authorNicename: DS.attr('string', readOnly: true)

  branches: DS.hasMany('Doers.Board')
  cards: DS.hasMany('Doers.Card')

  slug: (->
    'board-' + @get('id')
  ).property('id')
