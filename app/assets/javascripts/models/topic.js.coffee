Doers.Topic = DS.Model.extend Doers.LastUpdateMixin,
  title: DS.attr('string')
  description: DS.attr('string')
  position: DS.attr('number')
  updatedAt: DS.attr('date', readOnly: true)

  user: DS.belongsTo('user')
  project: DS.belongsTo('project')
  board: DS.belongsTo('board', inverse: 'topics')
  comments: DS.hasMany('comment', inverse:  'topic', readOnly: true, async: true)
  activities: DS.hasMany('activity', inverse: 'topic', readOnly: true, async: true)
  cards: DS.hasMany('card', inverse: 'topic', readOnly: true, async: true, polymorphic: true)

  aligned: ( ->
    @get('cards').findBy('alignment', true)
  ).property('cards.@each.alignment')

  moveSource: false
  moveTarget: false

  slug: (->
    'topic-' + @get('id')
  ).property('id', 'type')

  needsRepositioning: ( ->
    board = @get('board')
    if board
      board.topicsOrderChanged()
  ).observes('moveTarget')
