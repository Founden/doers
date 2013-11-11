Doers.TopicController =
Ember.ObjectController.extend Doers.ControllerAlertMixin,

  commentContent: ''
  cardPicker: false

  actions:
    save: ->
      topic = @get('content')
      if topic.get('title')
        topic.save().then =>
          mixpanel.track 'UPDATED',
            TYPE: 'Topic'
            ID: topic.get('id')
            TITLE: topic.get('title')

    destroy: ->
      topic = @get('content')
      board = @get('board')
      topic.deleteRecord()
      topic.save().then =>
        mixpanel.track 'DELETED',
          TYPE: 'Topic'
          ID: topic.get('id')
          TITLE: topic.get('title')
        @get('target.router').transitionTo('boards.show', board)

    addComment: ->
      content = @get('commentContent')
      if content and content.length > 1
        comment = @store.createRecord 'comment',
          content: content
          commentableId: @get('content.id')
          board: @get('board')
          project: @get('board.project')
          topic: @get('content')
          card: @get('content.card')
        comment.save().then =>
          @set('commentContent', '')
          @get('content').reload()
          mixpanel.track 'CREATED',
            TYPE: 'Comment'
            ID: comment.get('id')
            CONTENT: comment.get('content')

    resetComment: ->
      @set('commentContent', '')

    showCardPicker: ->
      @set('cardPicker', true)

    addCard: (type) ->
      topic = @get('content')
      card = @store.createRecord type.toLowerCase(),
        user: @get('currentUser')
        board: @get('board')
        project: @get('board.project')
        topic: topic
        type: type
        isEditing: true
      topic.get('cards').pushObject(card)
      @set('cardPicker', false)
