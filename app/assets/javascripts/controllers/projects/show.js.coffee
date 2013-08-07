Doers.ProjectsShowController = Ember.Controller.extend Doers.ControllerAlertMixin,
  publicBoards: ( ->
    Doers.Board.find(status: 'public')
  ).property()

  createFork: (board) ->
    project = @get('content')

    branch = Doers.Board.createRecord
      title: board.get('title')
      parentBoard: board
      project: project
    branch.save().then =>
      @get('target.router').transitionTo('boards.show', branch)
