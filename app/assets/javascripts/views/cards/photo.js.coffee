Doers.PhotoView = Ember.ContainerView.extend Doers.CardViewMixin,
  contentView: Ember.ContainerView.extend
    contentBinding: 'parentView.content'
    classNames: ['card-content']
    assetAttribute: 'image'
    childViews: ['titleView', 'textView', 'imageView', 'uploadView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    footerView: Doers.CardFooterView
    uploadView: Doers.AssetUploaderView.extend
      contentBinding: 'parentView.content'
      assetAttribute: 'image'
    imageView: Doers.CardImageView.extend
      contentBinding: 'parentView.content'
  editView: Ember.View.extend Doers.EditCardViewMixin
