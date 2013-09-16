Doers.ProjectsShowController = Ember.ArrayController.extend
  inviteEmail: ''

  update: ->
    if @get('project.title')
      @get('project').save()

  destroy: ->
    project = @get('project')
    project.one 'didDelete', =>
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
