Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    Doers.Board.createRecord()

Doers.BoardsYoursRoute = Ember.Route.extend
  model: ->
    Doers.Board.find(status: 'public')
