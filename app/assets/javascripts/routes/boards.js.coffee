Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:board').createRecord()

Doers.BoardsBuiltRoute = Ember.Route.extend
  model: ->
    @get('currentUser.authoredBoards')

  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')

Doers.BoardsShowRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('board', model)
    controller.set('content', model.get('cards'))

Doers.BoardsBuildRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('board', model)
    controller.set('content', model.get('cards'))

  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')
