Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    Doers.Project.createRecord()
