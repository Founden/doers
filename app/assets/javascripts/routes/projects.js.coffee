Doers.ProjectsIndexRoute = Ember.Route.extend
  model: ->
    @get('currentUser.createdProjects')

Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    @container.resolve('model:project').createRecord()

  events:
    willTransition: (trainsition) ->
      project = @get('controller.content')
      project.deleteRecord() if project.get('isNew')

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    @get('currentUser.startups')

  redirect: ->
    if @get('currentUser.isImporting')
      @transitionTo('projects.import-running')
