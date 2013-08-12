Doers.CardEditView = Ember.View.extend
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'
  isBuildingBinding: 'parentView.isBuilding'
  isVisibleBinding: 'isEditing'
  classNames: ['card-edit']

  templateName: ( ->
    if @get('content.type') and type = @get('content.type').toLowerCase()
      if @get('isBuilding')
        'cards/build/%@'.fmt(type)
      else
        'cards/edit/%@'.fmt(type)
  ).property('content.type')

  saveButtonView: Ember.View.extend
    contentBinding: 'parentView.content'
    isEditingBinding: 'parentView.isEditing'
    tagName: 'button'
    classNames: ['button', 'does-save']
    isVisibleBinding: 'content.isDirty'
    clickBinding: 'controller.saveCard'

  cancelButtonView: Ember.View.extend
    contentBinding: 'parentView.content'
    tagName: 'button'
    classNames: ['button', 'gray', 'does-cancel']
    clickBinding: 'controller.rollbackCard'
