Doers.NumberView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'numberView', 'footerView']
    titleView: Doers.CardTitleView
    numberView: Doers.CardNumberView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
  settingsView: Doers.CardSettingsView
