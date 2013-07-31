Doers.MapView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'imageMapView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    imageMapView: Doers.CardImageMapView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView.extend
    addressView: Doers.AddressAutocompleteView.extend
      contentBinding: 'parentView.content'
  settingsView: Doers.CardSettingsView
