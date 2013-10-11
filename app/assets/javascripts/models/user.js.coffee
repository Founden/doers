Doers.User = DS.Model.extend
  externalId: DS.attr('number', readOnly: true)
  nicename: DS.attr('string', readOnly: true)
  email: DS.attr('string', readOnly: true)
  angelListToken: DS.attr('string', readOnly: true)
  isImporting: DS.attr('boolean', readOnly: true)
  isAdmin: DS.attr('boolean', readOnly: true)
  startups: Ember.ArrayController.create()
  avatarUrl: DS.attr('string', readOnly: true)

  createdProjects: DS.hasMany('project', readOnly: true, inverse: 'user', async: true)
  sharedProjects: DS.hasMany('project', readOnly: true, inverse: 'user', async: true)
  authoredBoards: DS.hasMany('board', readOnly: true, inverse: 'author', async: true)
  branchedBoards: DS.hasMany('board', readOnly: true, inverse: 'user', async: true)
  publicBoards: DS.hasMany('board', readOnly: true, async: true)
  activities: DS.hasMany('activity', readOnly: true, inverse: 'user', async: true)
  invitations: DS.hasMany('invitation', readOnly: true, inverse: 'user', async: true)
  comments: DS.hasMany('comment', readOnly: true, async: true)

  startupsUrl: ( ->
    'https://api.angel.co/1/startup_roles?v=1&user_id=' +
      @get('externalId') + '&access_token=' + @get('angelListToken')
  ).property('angelListToken')

  didLoad: ->
    if @get('externalId')
      @loadStartups()
    @_super()

  loadStartups: ->
    url = @get('startupsUrl')

    $.ajax
      url: url
      dataType: 'jsonp'
      success: (response) =>
        startups = @get('startups')
        response.startup_roles.forEach ((role) =>
          if role.role == 'founder' || role.role == 'advisor'
            startup = role.startup
            startups.addObject @store.createRecord 'startup',
              id: startup.id
              title: startup.name
              description: startup.product_desc
              website: startup.company_url
              logoUrl: startup.thumb_url
        ) if response.startup_roles
