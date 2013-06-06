Doers.ProjectsImportController = Ember.ArrayController.extend
  selectedStartups: ( ->
    @filterProperty('isSelected', true)
  ).property('@each.isSelected')

  doImport: ->
    @get('selectedStartups')
