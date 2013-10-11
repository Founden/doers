Doers.MembershipsRoute = Ember.Route.extend
  model: ->
    @get('currentUser.createdProjects')
