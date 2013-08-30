Doers.CardFooterView = Ember.View.extend
  classNames: ['card-item-user']
  templateName: 'cards/_footer'
  contentBinding: 'parentView.content'
  isEditingBinding: 'parentView.isEditing'
