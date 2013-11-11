Doers.ProjectsAddBoardController  =
Ember.Controller.extend Doers.ControllerAlertMixin,
  actions:
    save: ->
      project = @get('project')
      board = @get('content')
      board.set('project', project)
      board.save().then =>
        mixpanel.track 'CREATED',
          TYPE: 'Board'
          ID: board.get('id')
          TITLE: board.get('title')
        project.reload()
        @get('target.router').transitionTo('boards.show', board)
