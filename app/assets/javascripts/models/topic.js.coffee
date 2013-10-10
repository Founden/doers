Doers.Topic = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  position: DS.attr('number')

  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  user: DS.belongsTo('user')
  board: DS.belongsTo('board', inverse: 'topics', readOnly: true)
  comments: DS.hasMany('comment', inverse:  'topic', readOnly: true, async: true)
  activities: DS.hasMany('activity', inverse: 'topic', readOnly: true, async: true)
  card: DS.belongsTo('card', inverse: 'topic', readOnly: true)

  # TODO: Set completed attribute
  completed: true

  moveSource: false
  moveTarget: false

  needsRepositioning: ( ->
    board = @get('board')
    if board
      board.topicsOrderChanged()
  ).observes('moveTarget')
