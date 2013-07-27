Doers.CardFooterView = Ember.View.extend
  tagName: 'footer'
  templateName: 'cards/_footer'
  contentBinding: 'parentView.content'

  editButton: Ember.View.extend
    tagName: 'a'

    click: (event) ->
      @toggleProperty('parentView.parentView.parentView.isEditing')