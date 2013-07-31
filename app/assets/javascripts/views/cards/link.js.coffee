Doers.LinkView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'embedView', 'footerView']
    titleView: Doers.CardTitleView
    embedView: Doers.CardEmbedView
    footerView: Doers.CardFooterView
    embedBinding: 'content.embed'
  editView: Doers.CardEditView.extend
    embedBinding: 'content.embed'
  settingsView: Doers.CardSettingsView
