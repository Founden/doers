Doers.IntervalView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'intervalView', 'footerView']
    titleView: Doers.CardTitleView
    intervalView: Doers.CardIntervalView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
