Doers.Card = DS.Model.extend
  ticker: Date.now()
  assetableType: 'Card'

  title: DS.attr('string')
  content: DS.attr('string')
  type: DS.attr('string')
  updatedAt: DS.attr('date', readOnly: true)

  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')
  topic: DS.belongsTo('Doers.Topic', inverse: 'card')
  user: DS.belongsTo('Doers.User', readOnly: true)
  activities: DS.hasMany('Doers.Activity', readOnly: true, polymorphic: true)
  comments: DS.hasMany('Doers.Comment', readOnly: true, inverse: 'card')
  endorses: DS.hasMany('Doers.Endorse', readOnly: true)

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
