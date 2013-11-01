Doers.ProjectsShowController =
  Ember.ArrayController.extend Doers.ControllerAlertMixin,

  inviteEmail: ''

  actions:
    update: ->
      project = @get('project')
      if project.get('title') and project.get('isDirty')
        project.save().then =>
          mixpanel.track 'UPDATED',
            TYPE: 'Project'
            ID: project.get('id')
            TITLE: project.get('title')

    destroy: ->
      project = @get('project')
      project.deleteRecord()
      project.save().then =>
        mixpanel.track 'DELETED',
          TYPE: 'Project'
          ID: project.get('id')
          TITLE: project.get('title')
        @get('target.router').transitionTo('projects.index')
