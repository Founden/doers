Doers.TimestampView = Ember.ContainerView.extend Doers.CardViewMixin,
  childViews: ['titleView', 'footerView']
  titleView: Doers.CardTitleView
  footerView: Doers.CardFooterView
  safeTimestamp: (->
    if timestamp = @get('content.content')
      timestamp.toString()
  ).property('content.content')
