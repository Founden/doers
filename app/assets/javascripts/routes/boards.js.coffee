Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:board').createRecord()

Doers.BoardsYoursRoute = Ember.Route.extend
  model: ->
    Doers.Board.find(status: 'public')
