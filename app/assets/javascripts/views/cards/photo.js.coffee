Doers.PhotoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'photoView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    photoView: Doers.CardPhotoView.extend
      contentBinding: 'parentView.content'
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView.extend
    uploadView: Doers.AssetUploaderView.extend
      contentBinding: 'parentView.content'
      assetAttribute: 'image'
  settingsView: Doers.CardSettingsView
