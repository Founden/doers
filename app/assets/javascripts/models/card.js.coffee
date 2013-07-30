Doers.Card = DS.Model.extend
  ticker: Date.now()
  assetableType: 'Card'

  title: DS.attr('string')
  content: DS.attr('string')
  position: DS.attr('number')
  type: DS.attr('string')
  style: DS.attr('string')

  project: DS.belongsTo('Doers.Project')
  board: DS.belongsTo('Doers.Board')
  user: DS.belongsTo('Doers.User', readOnly: true)

  updatedAt: DS.attr('date', readOnly: true)
  userNicename: DS.attr('string', readOnly: true)

  init: ->
    setInterval ( =>
      @set('ticker', Date.now())
    ), 60000
    @_super()

  slug: (->
    if type = @get('type')
      'card-%@-%@'.fmt(type.toLowerCase(), @get('id'))
  ).property('id', 'type')

  didUpdate: ->
    @set('updatedAt', new Date())

  lastUpdate: ( ->
    moment(@get('updatedAt')).fromNow()
  ).property('updatedAt', 'ticker')
