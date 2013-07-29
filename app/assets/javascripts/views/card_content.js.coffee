Doers.CardContentView = Ember.ContainerView.extend
  isEditingBinding: 'parentView.isEditing'
  contentBinding: 'parentView.content'
  classNames: ['card-content']
