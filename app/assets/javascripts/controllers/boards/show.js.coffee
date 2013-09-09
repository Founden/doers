Doers.BoardsShowController =
  Doers.CardsController.extend Doers.ControllerAlertMixin,
  selectedCardView: null

  update: ->
    if @get('board.title')
      @get('board').save()
