Doers.ProjectsShowController =
  Ember.ArrayController.extend Doers.ControllerAlertMixin,

  inviteEmail: ''

  actions:

    update: ->
      if @get('project.isDirty')
        @get('project').save()

    destroy: ->
      project = @get('project')
      project.one 'didDelete', =>
        @get('target.router').transitionTo('projects.index')
      project.deleteRecord()
      project.get('store').commit()

    createBranch: (board) ->
      project = @get('project')
      branch = @store.createRecord 'board',
        title: board.get('title')
        description: board.get('description')
        parentBoard: board
        project: project
      branch.save().then =>
        @get('content').pushObject(branch)
        $('body').animate({scrollTop: 100}, 200)

    invite: ->
      project = @get('project')
      if email = @get('inviteEmail')
        invitation = @store.createRecord 'invitation',
          email: email
          project: project
          invitableId: project.get('id')
          invitableType: 'Project'
        invitation.save().then =>
          @set('inviteEmail', '')
          if membership = invitation.get('membership')
            project.get('memberships').pushObject(membership)
