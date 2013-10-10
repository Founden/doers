Doers.BoardsShowController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,
  actions:

    update: ->
      if @get('board.title')
        @get('board').save()

    destroy: ->
      board = @get('board')
      project = board.get('project')
      board.one 'didDelete', =>
        @get('target.router').transitionTo('projects.show', project)
      board.deleteRecord()
      board.get('store').commit()
