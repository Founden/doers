Doers.ProjectsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,
  save: (view)->
    project = @get('content')
    project.save().then =>
      mixpanel.track 'Created project',
        id: project.get('id')
        title: project.get('title')
      @get('target.router').transitionTo('projects.show', project)
