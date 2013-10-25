Doers.ProjectsImportView = Ember.View.extend

  hasSelections: ( ->
    @get('controller.selectedStartups').length > 0
  ).property('controller.selectedStartups.length')

  startupView: Ember.View.extend
    classNames: ['project-item']
    classNameBindings: ['content.slug', 'content.isSelected:selected']

    click: (event) ->
      @toggleProperty('content.isSelected')
      false
