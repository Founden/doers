Doers.ProjectsImportController = Ember.ArrayController.extend
  selectedStartups: ( ->
    @filterProperty('isSelected', true)
  ).property('@each.isSelected')

  doImport: ->
    @get('selectedStartups').forEach (record) ->
      record.save()
    @get('target.router').transitionTo('projects.import-running')
