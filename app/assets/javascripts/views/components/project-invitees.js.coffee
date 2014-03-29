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
        @set('isEditing', false)
        @set('inviteEmail', '')
        project.reload()

    destroy: (membership) ->
      membership.deleteRecord()
      membership.save()

