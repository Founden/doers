Doers.IndexRoute = Ember.Route.extend
  redirect: ->
    this.transitionTo('projects')
