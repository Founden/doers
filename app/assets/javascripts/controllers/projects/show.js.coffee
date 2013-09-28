Doers.ProjectsShowController = Ember.ArrayController.extend
  inviteEmail: ''

  update: ->
    project = @get('project')
    if project.get('title')
      project.save().then =>
        mixpanel.track 'Updated project',
          id: project.get('id')
          title: project.get('title')

  destroy: ->
    project = @get('project')
    project.one 'didDelete', =>
      mixpanel.track 'Deleted project',
        id: project.get('id')
        title: project.get('title')
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
      mixpanel.track 'Branched board',
        id: board.get('id')
        title: board.get('title')

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
        mixpanel.track 'Shared project',
          id: project.get('id')
          title: project.get('title')
