Doers.BoardsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,

  save: ->
    board = @get('content')
    board.save().then =>
      @get('target.router').transitionTo('boards.build', board)
