Doers.PhotoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'imageView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    imageView: Doers.CardImageView.extend
      contentBinding: 'parentView.content'
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView.extend
    uploadView: Doers.AssetUploaderView.extend
      contentBinding: 'parentView.content'
      assetAttribute: 'image'
