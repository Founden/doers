Doers.BoardsShowController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,
  actions:

    update: ->
      if @get('board.title')
        @get('board').save()

    destroy: ->
      board = @get('board')
      project = board.get('project')
      board.deleteRecord()
      board.save().then =>
        mixpanel.track 'DELETED',
          TYPE: 'Board'
          ID: board.get('id')
          TITLE: board.get('title')
        @get('target.router').transitionTo('projects.show', project)
