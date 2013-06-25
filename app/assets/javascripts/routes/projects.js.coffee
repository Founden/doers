Doers.ProjectsNewRoute = Ember.Route.extend
  model: ->
    Doers.Project.createRecord()

Doers.ProjectsImportRoute = Ember.Route.extend
  model: ->
    me = Doers.User.find('mine')
    @set('user', me)
    me.get('startups')

  redirectIfImporting: ( ->
    if @get('user.importing')
      this.transitionTo('projects.import-running')
  ).observes('user.importing')
