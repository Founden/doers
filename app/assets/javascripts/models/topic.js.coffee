Doers.Topic = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  position: DS.attr('number')

  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User')
  board: DS.belongsTo('Doers.Board', inverse: 'topics', readOnly: true)
  comments: DS.hasMany('Doers.Comment', readOnly: true)
  activities: DS.hasMany('Doers.Activity', readOnly: true)
