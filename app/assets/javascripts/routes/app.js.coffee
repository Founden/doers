Doers.IndexRoute = Ember.Route.extend
  redirect: ->
    this.transitionTo('dashboard')
