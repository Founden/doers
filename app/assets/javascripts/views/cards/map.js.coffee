Doers.MapView = Ember.ContainerView.extend Doers.CardViewMixin,
  childViews: ['titleView', 'imageMapView']
  titleView: Doers.CardTitleView
  imageMapView: Doers.ImageMapView
