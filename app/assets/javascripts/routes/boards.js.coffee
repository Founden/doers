Doers.BoardsIndexRoute = Ember.Route.extend
  model: ->
    @get('currentUser.authoredBoards')

Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:board').createRecord()

  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')

Doers.BoardsShowRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('board', model)
    controller.set('content', model.get('topics'))

Doers.BoardsBuildRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('board', model)
    controller.set('content', model.get('cards'))
    controller.set('selectedCardView', null)

  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')
