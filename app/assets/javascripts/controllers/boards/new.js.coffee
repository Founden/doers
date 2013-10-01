Doers.BoardsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,

  save: ->
    board = @get('content')
    board.save().then =>
      mixpanel.track 'CREATED',
        TYPE: 'Board'
        ID: board.get('id')
        TITLE: board.get('title')
      @get('target.router').transitionTo('boards.build', board)
