Doers.User = DS.Model.extend
  externalId: DS.attr('number', readOnly: true)
  nicename: DS.attr('string', readOnly: true)
  angelListToken: DS.attr('string', readOnly: true)
  importing: DS.attr('boolean', readOnly: true)
  startups: Ember.ArrayController.create()

  startupsUrl: ( ->
    'https://api.angel.co/1/startup_roles?v=1&user_id=' +
      @get('externalId') + '&access_token=' + @get('angelListToken')
  ).property('angelListToken')


  startupsUrlObserver: ( ->
    url = @get('startupsUrl')
    self = @

    $.ajax
      url: url
      dataType: 'jsonp'
      jsonpCallback: '_cb'
      cache: true
      success: (response) ->
        startups = self.get('startups')
        response.startup_roles.forEach ((role) ->
          if role.role == 'founder' || role.role == 'advisor'
            startup = role.startup
            startups.addObject Doers.Startup.createRecord
              externalId: startup.id
              title: startup.name
              description: startup.product_desc
              website: startup.company_url
              logoUrl: startup.thumb_url
        )
  ).observes('startupsUrl')
