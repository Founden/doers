Doers.MembershipsController = Ember.Controller.extend
  inviteEmail: ''

  invite: (project) ->
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

  remove: (membership) ->
    type = membership.get('board.id') ? 'Board' : 'Project'
    mixpanel.track 'UNSHARED',
      TYPE: type
      ID: membership.get('board.id') || membership.get('project.id')
      TITLE: membership.get('board.title') || membership.get('project.title')
    membership.deleteRecord()
    membership.get('store').commit()
