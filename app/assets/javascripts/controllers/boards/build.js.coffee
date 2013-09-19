Doers.BoardsBuildController =
  Doers.CardsController.extend Doers.ControllerAlertMixin,
  sortProperties: ['position']
  inviteEmail: ''

  update: ->
    if @get('board.title')
      @get('board').save()

  destroy: ->
    board = @get('board')
    board.one 'didDelete', =>
      @get('target.router').transitionTo('boards')
    board.deleteRecord()
    board.get('store').commit()

  invite: ->
    board = @get('board')
    klass = @container.resolve('model:invitation')
    if email = @get('inviteEmail')
      invitation = klass.createRecord
        email: email
        board: board
        invitableId: board.get('id')
        invitableType: 'Board'
      invitation.save().then =>
        @set('inviteEmail', '')
        if membership = invitation.get('membership')
          board.get('memberships').pushObject(membership)
