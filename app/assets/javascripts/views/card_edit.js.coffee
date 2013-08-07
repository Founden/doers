Doers.CardEditView = Ember.View.extend
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'
  isVisibleBinding: 'isEditing'
  classNames: ['card-edit']

  templateName: ( ->
    if type = @get('content.type')
      'cards/edit/%@'.fmt(type.toLowerCase())
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
