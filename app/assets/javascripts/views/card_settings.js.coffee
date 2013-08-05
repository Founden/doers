Doers.CardSettingsView = Ember.View.extend
  templateName: 'card_settings'
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'
  classNames: ['card-settings']
  classNameBindings: ['isActive:active']
  styles: ['small', 'medium', 'large']
  isActive: false

  toggleButton: Ember.View.extend
    tagName: 'a'
    classNames: ['dropdown-toggle']
    click: (event) ->
      @toggleProperty('parentView.isActive')

  editButton: Ember.View.extend
    classNames: ['toggle-editing']
    tagName: 'li'
    click: (event) ->
      @toggleProperty('parentView.isEditing')
      @set('parentView.isActive', false)

  deleteButton: Ember.View.extend
    classNames: ['delete']
    tagName: 'li'

  changeStyleButton: Ember.View.extend
    tagName: 'li'
    contentBinding: 'parentView.content'
    classNameBindings: ['isSelected:selected']

    isSelected: ( ->
      @get('content.style') == @get('style')
    ).property('content.style', 'style')

    styleChar: ( ->
      @get('style').charAt(0)
    ).property('style')

    click: (event) ->
      @set('content.style', @get('style'))
      @set('parentView.isActive', false)
