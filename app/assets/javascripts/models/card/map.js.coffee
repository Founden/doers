Doers.MapMixin = Ember.Mixin.create
  latitude: DS.attr('number')
  longitude: DS.attr('number')
  query: null
  results: null
  isSearching: false
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
    Ember.run.debounce(@, 'search', 200)
  ).observes('query')

  search: ->
    @set('isSearching', true)
    $.ajax
      url: 'http://nominatim.openstreetmap.org/search'
      dataType: 'jsonp'
      jsonp: 'json_callback'
      data:
        q: @get('query')
        format: 'json'
      success: (response) =>
        @set('results', response)
        @set('isSearching', false)
      failure: =>
        @set('results', null)

Doers.Map = Doers.Card.extend(Doers.MapMixin)
