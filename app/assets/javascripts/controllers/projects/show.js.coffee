Doers.ProjectsShowController = Ember.Controller.extend Doers.ControllerAlertMixin, Doers.DeleteConfirmationMixin,

  createFork: (board) ->
    project = @get('content')

    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      parentBoard: board
      project: project
    branch.save().then =>
      @get('target.router').transitionTo('boards.show', branch)
