Doers.TopicController =
Ember.ObjectController.extend Doers.ControllerAlertMixin,

  commentContent: ''
  cardPicker: false

  actions:
    save: ->
      @get('content').save()

    addComment: ->
      content = @get('commentContent')

      if content and content.length > 1
        comment = @store.createRecord 'comment',
          content: content
          commentableId: @get('content.id')
          board: @get('board')
          project: @get('board.project')
        comment.save().then =>
          @set('commentContent', '')
          @get('content.activities').pushObject @store.createRecord 'activity',
            comment: comment
            lastUpdate: comment.get('updatedAt')

    resetComment: ->
      @set('commentContent', '')

    showCardPicker: ->
      @set('cardPicker', true)

    addCard: (type) ->
      card = @store.createRecord type.toLowerCase(),
        user: @get('currentUser')
        board: @get('board')
        project: @get('board.project')
        topic: @get('content')
        type: type
      @set('content.card', card)
