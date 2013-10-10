Doers.BoardsBuildController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,

  sortProperties: ['position']
  inviteEmail: ''

  actions:

    update: (event) ->
      if @get('board.isDirty')
        @get('board').save()

    destroy: ->
      board = @get('board')
      board.one 'didDelete', =>
        @get('target.router').transitionTo('boards')
      board.deleteRecord()
      board.get('store').commit()

    invite: ->
      board = @get('board')
      if email = @get('inviteEmail')
        invitation = @store.createRecord 'invitation',
          email: email
          board: board
          invitableId: board.get('id')
          invitableType: 'Board'
        invitation.save().then =>
          @set('inviteEmail', '')
          if membership = invitation.get('membership')
            board.get('memberships').pushObject(membership)

    addTopic: ->
      topic = @store.createRecord 'topic',
        board: @get('board')
        position: @get('content.length')
      @get('content').pushObject(topic)
