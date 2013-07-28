Doers.NumberView = Ember.ContainerView.extend Doers.CardViewMixin,
  contentView: Ember.ContainerView.extend
    contentBinding: 'parentView.content'
    classNames: ['card-content']
    childViews: ['titleView', 'textView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    footerView: Doers.CardFooterView
  editView: Ember.View.extend Doers.EditCardViewMixin
