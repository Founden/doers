Doers.MapView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'mapView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    mapView: Doers.CardMapView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
