Doers.LastUpdateMixin = Ember.Mixin.create

  ticker: Date.now()

  init: ->
    setInterval =>
      @set('ticker', Date.now())
    , 10000
    @_super()

  lastUpdate: ( ->
    moment(@get('updatedAt')).fromNow()
  ).property('updatedAt', 'ticker')
