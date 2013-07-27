Doers.ImageMapView = Ember.View.extend
    tagName: 'img'
    classNames: ['image']
    attributeBindings: ['src']
    src: ( ->
      latitude = @get('parentView.content.latitude')
      longitude = @get('parentView.content.longitude')
      params = $.param
        center: '%@,%@'.fmt(latitude, longitude)
        zoom: 10
        size: '300x300'
        sensor: false
      'http://maps.googleapis.com/maps/api/staticmap?%@'.fmt(params)
    ).property()
