Doers.CardImageMapView = Ember.View.extend
    tagName: 'img'
    classNames: ['image']
    attributeBindings: ['src']
    contentBinding: 'parentView.content'
    src: ( ->
      latitude = @get('content.latitude')
      longitude = @get('content.longitude')
      params = $.param
        center: '%@,%@'.fmt(latitude, longitude)
        zoom: 12
        size: '300x300'
        sensor: false
      'http://maps.googleapis.com/maps/api/staticmap?%@'.fmt(params)
    ).property('content.latitude', 'content.longitude')
