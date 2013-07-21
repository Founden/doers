Doers.MapView = Ember.View.extend
  templateName: 'cards/map'

  imageMap: Ember.View.extend
    tagName: 'img'
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