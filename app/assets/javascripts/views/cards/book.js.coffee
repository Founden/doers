Doers.BookView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'bookContentView', 'footerView']
    titleView: Doers.CardTitleView
    bookContentView: Doers.CardBookContentView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
