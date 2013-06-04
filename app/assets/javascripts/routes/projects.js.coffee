Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    Doers.Project.createRecord()

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    me = Doers.User.find('mine')
    me.get('startups')
