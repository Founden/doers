Doers.PhotoView = Ember.ContainerView.extend Doers.CardViewMixin,
  assetAttribute: 'image'
  childViews: ['titleView', 'uploadView', 'imageView']
  titleView: Doers.CardTitleView
  uploadView: Doers.AssetUploaderView.extend
    contentBinding: 'parentView.content'
    assetAttribute: 'image'
  imageView: Ember.View.extend
    contentBinding: 'parentView.content'
    templateName: 'cards/photo'
