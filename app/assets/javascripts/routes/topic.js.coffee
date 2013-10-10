Doers.TopicRoute = Ember.Route.extend
  model: (params) ->
    board_id = @modelFor('board').get('id')
    @store.find('topic', {ids: params.topic_id, board_id: board_id}).then (q) =>
      q.get('firstObject')

  setupController: (controller, model) ->
    @_super(controller, model)
    controller.set('board', @modelFor('board'))
