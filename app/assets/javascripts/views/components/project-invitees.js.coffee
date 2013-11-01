Doers.ProjectInviteesComponent = Ember.Component.extend
  classNames: ['project-invitees']
  isEditing: false
  inviteEmail: ''

  actions:
    toggleEdit: ->
      @toggleProperty('isEditing')

    invite: ->
      project = @get('content')
      invitation = @get('content.store').createRecord 'invitation',
        email: @get('inviteEmail')
        project: project
        invitableId: project.get('id')
        invitableType: 'Project'
      invitation.save().then =>
        mixpanel.track 'SHARED',
          TYPE: 'Project'
          ID: project.get('id')
          TITLE: project.get('title')
        @set('isEditing', false)
        @set('inviteEmail', '')
        project.reload()

    destroy: (membership) ->
      mixpanel.track 'UNSHARED',
        TYPE: 'Project'
        ID: membership.get('project.id')
        TITLE: membership.get('project.title')
      membership.deleteRecord()
      membership.save()

