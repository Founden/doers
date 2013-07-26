Doers.ProjectsShowController = Ember.Controller.extend Doers.ControllerAlertMixin,
  publicBoards: ( ->
    Doers.Board.find({status: 'public'})
  ).property()

  createFork: (board) ->
    fork = Doers.Board.createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: @get('content')
    fork.save().then =>
      @get('target.router').transitionTo('boards.show', @get('content'), fork)

