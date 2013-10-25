Doers.TopicRoute = Ember.Route.extend

  setupController: (controller, model) ->
    controller.set('content', model)
    controller.set('board', model.get('board'))
