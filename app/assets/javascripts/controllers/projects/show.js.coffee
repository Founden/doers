Doers.ProjectsShowController = Ember.Controller.extend
  inviteEmail: ''

  update: ->
    if @get('content.title')
      @get('content').save()

  destroy: ->
    project = @get('content')
    project.one 'didDelete', =>
      @get('target.router').transitionTo('projects.index')
    project.deleteRecord()
    project.get('store').commit()

  createBranch: (board) ->
    project = @get('content')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: project
    branch.save()

  invite: ->
    project = @get('content')
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
