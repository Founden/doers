Doers.PhotoView = Ember.ContainerView.extend Doers.CardViewMixin,
  assetAttribute: 'image'
  childViews: ['titleView', 'imageView', 'uploadView', 'footerView']
  titleView: Doers.CardTitleView
  footerView: Doers.CardFooterView
  uploadView: Doers.AssetUploaderView.extend
    contentBinding: 'parentView.content'
    assetAttribute: 'image'
  imageView: Doers.CardImageView.extend
    contentBinding: 'parentView.content'
