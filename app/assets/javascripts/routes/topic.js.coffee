Doers.TopicRoute = Ember.Route.extend

  setupController: (controller, model) ->
    @_super(controller, model)
    controller.set('board', @modelFor('board'))
