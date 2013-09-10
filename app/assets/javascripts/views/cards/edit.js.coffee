Doers.CardEditView = Ember.View.extend
  classNames: ['card']
  classNameBindings: ['content.editSlug']
  contentBinding: 'controller.selectedCardView.content'
  isVisibleBinding: 'content.isEditing'
  uploadView: Doers.UploaderView

  saveButtonView: Ember.View.extend
    contentBinding: 'parentView.content'
    clickBinding: 'controller.save'
