Doers.ProjectsIndexRoute = Ember.Route.extend
  model: ->
    @get('currentUser').reload().then =>
      @get('currentUser.createdProjects')

Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord('project')

  actions:
    willTransition: (trainsition) ->
      project = @get('controller.content')
      project.deleteRecord() if project.get('isNew')

Doers.ProjectsShowRoute = Ember.Route.extend
  setupController: (controller, model)->
    controller.set('project', model)
    controller.set('content', model.get('boards'))

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    @get('currentUser.startups')

  redirect: ->
    if @get('currentUser.isImporting')
      @transitionTo('projects.import-running')

Doers.ProjectsAddBoardRoute = Ember.Route.extend

  setupController: (controller, model) ->
    controller.set('project', model)
    controller.set('content', @store.createRecord('board'))
