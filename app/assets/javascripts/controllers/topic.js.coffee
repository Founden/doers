Doers.TopicController = Ember.Controller.extend

  commentContent: ''

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
