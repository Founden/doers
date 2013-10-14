Doers.Card = DS.Model.extend
  ticker: Date.now()
  assetableType: 'Card'

  title: DS.attr('string')
  content: DS.attr('string')
  type: DS.attr('string')
  alignment: DS.attr('boolean', default: false)
  updatedAt: DS.attr('date', readOnly: true)

  project: DS.belongsTo('project')
  board: DS.belongsTo('board')
  topic: DS.belongsTo('topic', inverse: 'card')
  user: DS.belongsTo('user', readOnly: true)
  comments: DS.hasMany('comment', readOnly: true, inverse: 'card', async: true)
  endorses: DS.hasMany('endorse', readOnly: true, inverse: 'card', async: true)

  isEditing: false

  init: ->
    setInterval ( =>
      @set('ticker', Date.now())
    ), 60000
    @_super()

  slug: (->
    'card-' + @get('id')
  ).property('id', 'type')

  didUpdate: ->
    @set('updatedAt', new Date())

  lastUpdate: ( ->
    moment(@get('updatedAt')).fromNow()
  ).property('updatedAt', 'ticker')
