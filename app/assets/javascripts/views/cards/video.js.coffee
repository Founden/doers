Doers.VideoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView
