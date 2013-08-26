Doers.User = DS.Model.extend
  externalId: DS.attr('number', readOnly: true)
  nicename: DS.attr('string', readOnly: true)
  angelListToken: DS.attr('string', readOnly: true)
  isImporting: DS.attr('boolean', readOnly: true)
  isAdmin: DS.attr('boolean', readOnly: true)
  startups: Ember.ArrayController.create()
  avatarUrl: DS.attr('string', readOnly: true)

  createdProjects: DS.hasMany('Doers.Project', readOnly: true, inverse: 'user')
  sharedProjects: DS.hasMany('Doers.Project', readOnly: true, inverse: 'user')
  authoredBoards: DS.hasMany('Doers.Board', readOnly: true, inverse: 'author')
  branchedBoards: DS.hasMany('Doers.Board', readOnly: true, inverse: 'user')
  publicBoards: DS.hasMany('Doers.Board', readOnly: true)
  activities: DS.hasMany('Doers.Activity', readOnly: true, inverse: 'user')

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
    self = @

    startupClass = @store.container.resolve('model:angel_list_startup')

    $.ajax
      url: url
      dataType: 'jsonp'
      success: (response) ->
        startups = self.get('startups')
        response.startup_roles.forEach ((role) ->
          if role.role == 'founder' || role.role == 'advisor'
            startup = role.startup
            startups.addObject startupClass.create
              id: startup.id
              title: startup.name
              description: startup.product_desc
              website: startup.company_url
              logoUrl: startup.thumb_url
        ) if response.startup_roles
