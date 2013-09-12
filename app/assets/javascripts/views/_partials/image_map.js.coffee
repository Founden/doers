Doers.ImageMapView = Ember.View.extend
  tagName: 'img'
  attributeBindings: ['src']
  zoom: 12
  size: '300x300'
  sensor: false

  params: ( ->
    center = [@get('content.latitude'), @get('content.longitude')].join(',')
    $.param
      center: center
      zoom: @get('zoom')
      size: @get('size')
      sensor: @get('sensor')
  ).property('content.latitude', 'content.longitude')

  src: ( ->
    'http://maps.googleapis.com/maps/api/staticmap?%@'.fmt(@get('params'))
  ).property('params')
