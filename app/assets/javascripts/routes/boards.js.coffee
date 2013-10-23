Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord('board')

Doers.BoardsShowRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('board', model)
    controller.set('content', model.get('topics'))
