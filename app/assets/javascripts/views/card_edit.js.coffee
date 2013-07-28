Doers.CardEditView = Ember.View.extend
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'
  isVisibleBinding: 'isEditing'
  classNames: ['card-edit']
  templateName: 'cards/edit/phrase'

  saveButtonView: Ember.View.extend
    contentBinding: 'parentView.content'
    isEditingBinding: 'parentView.isEditing'
    tagNames: 'input'
    attributeBindings: ['type']
    type: 'submit'
    classNames: ['button']

    click: ->
      @get('content').save().then =>
        @set('isEditing', false)
