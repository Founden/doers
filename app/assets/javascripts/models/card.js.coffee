Doers.Card = DS.Model.extend
  title: DS.attr('string')
  content: DS.attr('string')
  key: DS.attr('string')

  updatedAt: DS.attr('date')
  lastUpdate: DS.attr('string')
  userNicename: DS.attr('string')

  user: DS.belongsTo('Doers.User')
  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')

  slug: (->
    'card-' + @get('id')
  ).property('id')
