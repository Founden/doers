Doers.ProjectsIndexRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:project').find()

Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:project').createRecord()

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    @get('currentUser.startups')

  redirect: ->
    if @get('currentUser.isImporting')
      @transitionTo('projects.import-running')
