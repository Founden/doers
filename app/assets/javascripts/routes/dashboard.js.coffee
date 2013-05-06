Doers.DashboardRoute = Ember.Route.extend
  model: ->
    Doers.Project.find()
