Doers.Card = DS.Model.extend
  title: DS.attr('string')
  type: DS.attr('string')
  position: DS.attr('number')

  updatedAt: DS.attr('date')
  lastUpdate: DS.attr('string')
  userNicename: DS.attr('string')

  user: DS.belongsTo('Doers.User')
  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')

  slug: (->
    if type = @get('type')
      'card-%@-%@'.fmt(type.toLowerCase(), @get('id'))
  ).property('id', 'type')
