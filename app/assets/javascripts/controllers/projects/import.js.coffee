Doers.ProjectsImportController = Ember.ArrayController.extend
  selectedStartups: ( ->
    @filterProperty('isSelected', true)
  ).property('@each.isSelected')

  doImport: ->
    startupClass = @container.resolve('model:startup')
    @get('selectedStartups').forEach (record) ->
      startupClass.createRecord(externalId: record.id).save()

    @get('target.router').transitionTo('projects.import-running')
