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
    classNames: ['project']
    classNameBindings: ['content.slug', 'content.isSelected:selected']

    websiteText: ( ->
      if www = @get('content.website')
        www.match('https?://(.*[^/])')[1]
      else
        'N/A'
    ).property('content.website')

    click: (event) ->
      @toggleProperty('content.isSelected')
      false
