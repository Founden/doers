Doers.PhraseView = Ember.ContainerView.extend Doers.CardViewMixin,
  childViews: ['contentView', 'editView']

  contentView: Ember.ContainerView.extend
    contentBinding: 'parentView.content'
    classNames: ['card-content']
    childViews: ['titleView', 'textView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    footerView: Doers.CardFooterView

  editView: Ember.View.extend
    contentBinding: 'parentView.content'
    templateName: 'cards/edit/phrase'
    classNames: ['card-edit']
    isVisibleBinding: 'parentView.isEditing'