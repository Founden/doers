Doers.TimestampView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'timestampView', 'footerView']
    titleView: Doers.CardTitleView
    timestampView: Doers.CardTimestampView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
