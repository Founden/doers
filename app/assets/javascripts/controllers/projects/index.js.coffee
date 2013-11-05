Doers.ProjectsIndexController = Ember.Controller.extend

  hasProjects: ( ->
    @get('content') or @get('currentUser.sharedProjects')
  ).property('content', 'currentUser.sharedProjects')
