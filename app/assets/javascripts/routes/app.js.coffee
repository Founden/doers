Doers.IndexRoute = Ember.Route.extend
  redirect: ->
    @transitionTo('projects.index')
