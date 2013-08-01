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
    tagNames: 'button'
    classNames: ['button']

    clickBinding: 'controller.saveCard'

  cancelButtonView: Ember.View.extend
    tagNames: 'button'
    classNames: ['button', 'gray']

    click: (event) ->
      @set('parentView.isEditing', false)

