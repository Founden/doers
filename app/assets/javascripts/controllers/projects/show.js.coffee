Doers.ProjectsShowController =
  Ember.ArrayController.extend Doers.ControllerAlertMixin,

  inviteEmail: ''

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
    project.one 'didDelete', =>
      mixpanel.track 'DELETED',
        TYPE: 'Project'
        ID: project.get('id')
        TITLE: project.get('title')
      @get('target.router').transitionTo('projects.index')
    project.deleteRecord()
    project.get('store').commit()

  createBranch: (board) ->
    project = @get('project')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: project
    branch.save().then =>
      @get('content').pushObject(branch)
      $('body').animate({scrollTop: 100}, 200)
      mixpanel.track 'BRANCHED',
        TYPE: 'Board'
        ID: board.get('id')
        TITLE: board.get('title')

  invite: ->
    project = @get('project')
    klass = @container.resolve('model:invitation')
    if email = @get('inviteEmail')
      invitation = klass.createRecord
        email: email
        project: project
        invitableId: project.get('id')
        invitableType: 'Project'
      invitation.save().then =>
        @set('inviteEmail', '')
        if membership = invitation.get('membership')
          project.get('memberships').pushObject(membership)
        mixpanel.track 'SHARED',
          TYPE: 'Project'
          ID: project.get('id')
          TITLE: project.get('title')
