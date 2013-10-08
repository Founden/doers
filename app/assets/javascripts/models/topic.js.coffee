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
  endorses: DS.hasMany('Doers.Endorse', readOnly: true)
  card: DS.belongsTo('Doers.Card', readOnly: true, inverse: 'topic')

  # TODO: Set completed attribute
  completed: true

  moveSource: false
  moveTarget: false

  needsRepositioning: ( ->
    board = @get('board')
    if board
      board.topicsOrderChanged()
  ).observes('moveTarget')
