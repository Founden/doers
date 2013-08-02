Doers.MapMixin = Ember.Mixin.create
  latitude: DS.attr('number')
  longitude: DS.attr('number')

  query: null
  results: null
  zoom: 12
  size: '640x320'

  params: ( ->
    $.param
      center: '%@,%@'.fmt(@get('latitude'), @get('longitude'))
      zoom: @get('zoom')
      size: @get('size')
      sensor: false
  ).property('latitude', 'longitude', 'zoom', 'size')

  queryChanged: ( ->
    query = @get('query')
    if query and query.length > 3
      $.ajax
        url: 'http://nominatim.openstreetmap.org/search'
        dataType: 'json'
        data:
          q: query
          format: 'json'
        success: (response) =>
          @set('results', response)
        failure: =>
          @set('results', null)
  ).observes('query')

Doers.Map = Doers.Card.extend(Doers.MapMixin)
