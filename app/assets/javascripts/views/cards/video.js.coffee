Doers.VideoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'videoContentView', 'footerView']
    titleView: Doers.CardTitleView
    videoContentView: Doers.CardVideoContentView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
