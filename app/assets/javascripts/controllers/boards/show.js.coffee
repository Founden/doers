Doers.BoardsShowController =
  Doers.CardsController.extend Doers.ControllerAlertMixin,
  selectedCardView: null

  update: ->
    if @get('board.title')
      @get('board').save()

  destroy: ->
    board = @get('board')
    project = board.get('project')
    board.deleteRecord()
    board.get('store').commit()
    @get('target.router').transitionTo('projects.show', project)