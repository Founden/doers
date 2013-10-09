Doers.TopicController =
Ember.ObjectController.extend Doers.ControllerAlertMixin,

  commentContent: ''
  cardPicker: false

  addComment: ->
    klass = @container.resolve('model:comment')
    activityKlass = @container.resolve('model:activity')
    content = @get('commentContent')

    if content and content.length > 1
      comment = klass.createRecord
        content: content
        commentableId: @get('content.id')
        board: @get('board')
        project: @get('board.project')
      comment.save().then =>
        @set('commentContent', '')
        @get('content.activities').pushObject activityKlass.createRecord
          comment: comment
          lastUpdate: comment.get('updatedAt')

  resetComment: ->
    @set('commentContent', '')

  showCardPicker: ->
    @set('cardPicker', true)

  addCard: (type) ->
    klass = @container.resolve('model:' + type)
    card = klass.createRecord
      user: @get('currentUser')
      board: @get('board')
      project: @get('board.project')
      topic: @get('content')
      type: type
