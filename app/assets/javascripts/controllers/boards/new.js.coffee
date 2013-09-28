Doers.BoardsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,

  save: ->
    board = @get('content')
    board.save().then =>
      mixpanel.track 'Created board',
        id: board.get('id')
        title: board.get('title')
      @get('target.router').transitionTo('boards.build', board)
