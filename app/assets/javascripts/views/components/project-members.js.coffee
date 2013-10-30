Doers.ProjectMembersComponent = Ember.Component.extend
  tagName: ['ul']
  classNames: ['project-members']

  isOwner: ( ->
    @get('content.user') == @get('user')
  ).property('content.user', 'user')

  actions:
    destroy: (membership) ->
      mixpanel.track 'UNSHARED',
        TYPE: 'Project'
        ID: membership.get('project.id')
        TITLE: membership.get('project.title')
      membership.deleteRecord()
      membership.save()

