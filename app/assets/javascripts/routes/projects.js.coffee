Doers.ProjectsIndexRoute = Ember.Route.extend
  model: ->
    Doers.Project.find()

Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    Doers.Project.createRecord()

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    @get('currentUser.startups')

  redirect: ->
    if @get('currentUser.isImporting')
      @transitionTo('projects.import-running')
