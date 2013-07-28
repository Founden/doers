Doers.ProjectsShowController = Ember.Controller.extend Doers.ControllerAlertMixin,
  publicBoards: null

  publicBoardsObserver: ( ->
    unless @get('content.boards').length > 0
      @set('publicBoards', Doers.Board.find({status: 'public'}))
  ).observes('content.boards')

  createFork: (board) ->
    project = @get('content')

    fork = Doers.Board.createRecord
      title: board.get('title')
      parentBoard: board
      project: project
    fork.save().then =>
      @get('target.router').transitionTo('boards.show', project, fork)

