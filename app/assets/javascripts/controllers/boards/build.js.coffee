Doers.BoardsBuildController =
  Doers.CardsController.extend Doers.ControllerAlertMixin,
  sortProperties: ['position']
  selectedCardView: null

  update: ->
    if @get('board.title')
      @get('board').save()

  destroy: ->
    board = @get('board')
    board.one 'didDelete', =>
      @get('target.router').transitionTo('boards')
    board.deleteRecord()
    board.get('store').commit()
