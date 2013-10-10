Doers.BoardsShowController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,

  update: ->
    if @get('board.title')
      @get('board').save()

  destroy: ->
    board = @get('board')
    project = board.get('project')
    board.one 'didDelete', =>
      @get('target.router').transitionTo('projects.show', project)
    board.deleteRecord()
    mixpanel.track 'DELETED',
      TYPE: 'Board'
      ID: board.get('id')
      TITLE: board.get('title')
    board.get('store').commit()
