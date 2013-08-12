Doers.BoardsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:board').createRecord()

Doers.BoardsBuiltRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:board').find(status: 'public')

  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')

Doers.BoardsBuildRoute = Ember.Route.extend
  redirect: ->
    unless @get('currentUser.isAdmin')
      @transitionTo('projects.index')
