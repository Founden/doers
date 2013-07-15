Doers.Card = DS.Model.extend
  title: DS.attr('string')
  position: DS.attr('number')
  type: DS.attr('string')

  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')
  user: DS.belongsTo('Doers.User', readOnly: true)

  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)
  userNicename: DS.attr('string', readOnly: true)

  slug: (->
    if type = @get('type')
      'card-%@-%@'.fmt(type.toLowerCase(), @get('id'))
  ).property('id', 'type')
