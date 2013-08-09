Doers.BoardItemController = Ember.ObjectController.extend
  requiresConfirmation: false

  confirm: ->
    @set('requiresConfirmation', true)

  cancel: ->
    @set('requiresConfirmation', false)

  remove: ->
    board = @get('content')
    board.deleteRecord()
    board.get('store').commit()
