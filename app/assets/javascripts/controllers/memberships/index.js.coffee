Doers.MembershipsIndexController = Ember.Controller.extend
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
        mixpanel.track 'Shared project',
          id: project.get('id')
          title: project.get('title')

  remove: (membership) ->
    membership.deleteRecord()
    membership.get('store').commit()
