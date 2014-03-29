Doers.ProjectsShowController =
  Ember.ArrayController.extend Doers.ControllerAlertMixin,

  inviteEmail: ''

  isOwner: ( ->
    @get('project.user') == @get('currentUser')
  ).property('project.user', 'currentUser')

  isNotOwner: ( ->
    !@get('isOwner')
  ).property('isOwner')

  actions:
    update: ->
      project = @get('project')
      if project.get('title') and project.get('isDirty')
        project.save()

    destroy: ->
      project = @get('project')
      project.deleteRecord()
      project.save().then =>
        @get('target.router').transitionTo('projects.index')
