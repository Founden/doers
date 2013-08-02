Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    Doers.Board.createRecord()
