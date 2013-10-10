Doers.BoardsBuildController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,

  sortProperties: ['position']
  inviteEmail: ''

  update: ->
    board = @get('board')
    if board.get('title') and board.get('isDirty')
      board.save().then =>
        mixpanel.track 'UPDATED',
          TYPE: 'Board'
          ID: board.get('id')
          TITLE: board.get('title')

  destroy: ->
    board = @get('board')
    board.one 'didDelete', =>
      mixpanel.track 'DELETED',
        TYPE: 'Board'
        ID: board.get('id')
        TITLE: board.get('title')
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
        mixpanel.track 'SHARED',
          TYPE: 'Board'
          ID: board.get('id')
          TITLE: board.get('title')
          EMAIL: email

  addTopic: ->
    klass = @container.resolve('model:topic')
    topic = klass.createRecord
      board: @get('board')
      position: @get('content.length')
    @get('content').pushObject(topic)

  saveTopic: (topic) ->
    topic.save()

  removeTopic: (topic) ->
    topic.deleteRecord()
    topic.get('store').commit()
