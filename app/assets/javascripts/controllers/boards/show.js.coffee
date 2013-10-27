Doers.BoardsShowController =
Ember.ArrayController.extend Doers.ControllerAlertMixin,

  sortProperties: ['position']

  actions:

    update: ->
      if @get('board.title')
        @get('board').save()

    destroy: ->
      board = @get('board')
      project = board.get('project')
      board.deleteRecord()
      board.save().then =>
        @get('target.router').transitionTo('projects.show', project)
        mixpanel.track 'DELETED',
          TYPE: 'Board'
          ID: board.get('id')
          TITLE: board.get('title')

    addTopic: ->
      topic = @store.createRecord 'topic',
        board: @get('board')
        project: @get('board.project')
        position: @get('content.length')
      @get('content').pushObject(topic)

    saveTopic: (topic) ->
      topic.save()

    removeTopic: (topic) ->
      if topic.get('isNew')
        @get('content').removeObject(topic)
      else
        topic.deleteRecord()
        topic.save()
