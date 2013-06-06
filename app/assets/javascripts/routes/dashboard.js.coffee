Doers.DashboardRoute = Ember.Route.extend
  model: ->
    Doers.Project.all()
