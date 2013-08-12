Doers.ProjectsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,
  save: (view)->
    project = @get('content')
    if project.get('title') and project.get('website')
      project.save().then =>
        @get('target.router').transitionTo('projects.show', project)
    else
      @alertFromView(view)

  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('projects.index')
