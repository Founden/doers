Doers.MembershipsIndexRoute = Ember.Route.extend
  model: ->
    @get('currentUser.createdProjects')
