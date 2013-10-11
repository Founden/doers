Doers.ProjectsImportController = Ember.ArrayController.extend
  selectedStartups: ( ->
    @filterProperty('isSelected', true)
  ).property('@each.isSelected')

  actions:
    doImport: ->
      @get('selectedStartups').forEach (record) =>
        @store.createRecord('startup', externalId: record.id).save()

      mixpanel.track 'IMPORTED',
        TYPE: 'Startup'
        COUNT: @get('selectedStartups.length')
      @get('target.router').transitionTo('projects.import-running')
