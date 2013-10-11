Doers.ProjectsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,
  actions:
    save: (view)->
      project = @get('content')
      project.save().then =>
        mixpanel.track 'CREATED',
          TYPE: 'Project'
          ID: project.get('id')
          TITLE: project.get('title')
        @get('target.router').transitionTo('projects.show', project)

    cancel: ->
      @get('content').deleteRecord()
      @get('target.router').transitionTo('projects.index')
