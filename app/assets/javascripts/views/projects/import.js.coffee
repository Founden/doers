Doers.ProjectsImportView = Ember.View.extend
  templateName: 'projects/import'
  # Import status view
  statusView: Ember.View.extend
    classNames: ['status', 'row']
    hasSelections: ( ->
      @get('controller.selectedStartups').length > 0
    ).property('controller.selectedStartups.length')

  # Startup entry view
  startupView: Ember.View.extend
    classNames: ['project-item']
    classNameBindings: ['content.slug', 'content.isSelected:selected']

    click: (event) ->
      @toggleProperty('content.isSelected')
      false
