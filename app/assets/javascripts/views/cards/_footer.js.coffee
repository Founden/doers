Doers.CardFooterView = Ember.View.extend
  tagName: 'footer'
  templateName: 'cards/_footer'
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'

  editButton: Ember.View.extend
    tagName: 'a'
    click: ->
      @toggleProperty('parentView.isEditing')
