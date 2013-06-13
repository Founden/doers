Doers.DashboardController = Ember.ArrayController.extend
  # Return only projects that were saved, filter temporary objects
  projects: ( ->
    @filterProperty('isNew', false)
  ).property('@each.isNew')
