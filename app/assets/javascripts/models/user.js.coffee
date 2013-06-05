Doers.User = DS.Model.extend
  angelListId: DS.attr('number')
  nicename: DS.attr('string')
  angelListToken: DS.attr('string')
  startups: Ember.ArrayController.create()

  startupsUrl: ( ->
    'https://api.angel.co/1/startup_roles?v=1&callback=c&user_id=' +
      @get('angelListId')
  ).property('angelListId')


  startupsObserver: ( ->
    url = @get('startupsUrl')
    self = @

    $.ajax
      url: url
      dataType: 'jsonp'
      success: (response) ->
        response.startup_roles.forEach ((role) ->
          if role.role == 'founder'
            startup = role.startup
            self.get('startups').addObject Doers.Project.createRecord
              angelListId: startup.id
              title: startup.name
              logoUrl: startup.logo_url
              description: startup.product_desc
              website: startup.company_url
        )
  ).observes('startupsUrl')
