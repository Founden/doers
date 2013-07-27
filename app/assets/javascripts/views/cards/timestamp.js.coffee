Doers.TimestampView = Ember.ContainerView.extend Doers.CardViewMixin,
  childViews: ['titleView']
  titleView: Doers.CardTitleView
  safeTimestamp: (->
    if timestamp = @get('content.content')
      timestamp.toString()
  ).property('content.content')
