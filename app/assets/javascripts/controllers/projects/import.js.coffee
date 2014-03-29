Doers.ProjectsImportController = Ember.ArrayController.extend
  selectedStartups: ( ->
    @filterProperty('isSelected', true)
  ).property('@each.isSelected')

  actions:
    doImport: ->
      @get('selectedStartups').forEach (record) =>
        @store.createRecord('startup', externalId: record.id).save()

      @get('target.router').transitionTo('projects.import-running')
