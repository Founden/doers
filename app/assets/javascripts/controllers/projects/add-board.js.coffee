Doers.ProjectsAddBoardController  =
Ember.Controller.extend Doers.ControllerAlertMixin,
  actions:
    save: ->
      project = @get('project')
      board = @get('content')
      board.set('project', project)
      board.save().then =>
        project.reload()
        @get('target.router').transitionTo('boards.show', board)
