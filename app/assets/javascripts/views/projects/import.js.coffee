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
    classNameBindings: ['startupId', 'selected']

    startupId: ( ->
      'startup-' + @get('startup.angelListId')
    ).property('startup.angelListId')

    selected: ( ->
      @get('startup.isSelected')
    ).property('startup.isSelected')

    websiteText: ( ->
      www = @get('startup.website')
      if www
        @get('startup.website').match('https?://(.*[^/])')[1]
      else
        'N/A'
    ).property('startup')

    click: ->
      @toggleProperty('startup.isSelected')
