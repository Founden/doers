Doers.PhotoView = Ember.ContainerView.extend Doers.CardViewMixin,
  assetAttribute: 'image'
  childViews: ['uploadView', 'imageView']
  uploadView: Doers.AssetUploaderView.extend
    contentBinding: 'parentView.content'
    assetAttribute: 'image'
  imageView: Ember.View.extend
    contentBinding: 'parentView.content'
    templateName: 'cards/photo'
