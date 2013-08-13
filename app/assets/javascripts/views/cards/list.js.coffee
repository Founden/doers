Doers.ListView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'itemsView', 'footerView']
    titleView: Doers.CardTitleView
    itemsView: Doers.CardItemsView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
