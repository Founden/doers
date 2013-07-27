Doers.MapView = Ember.ContainerView.extend Doers.CardViewMixin,
  contentView: Ember.ContainerView.extend
    contentBinding: 'parentView.content'
    classNames: ['card-content']
    childViews: ['titleView', 'textView', 'imageMapView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    imageMapView: Doers.CardImageMapView
    footerView: Doers.CardFooterView
  editView: Ember.View.extend
    contentBinding: 'parentView.content'
    templateName: 'cards/edit/phrase'
    classNames: ['card-edit']
    isVisibleBinding: 'parentView.isEditing'
