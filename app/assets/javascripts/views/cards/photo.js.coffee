Doers.PhotoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'imageView', 'uploadView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    uploadView: Doers.AssetUploaderView.extend
      contentBinding: 'parentView.content'
      assetAttribute: 'image'
    imageView: Doers.CardImageView.extend
      contentBinding: 'parentView.content'
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
