Doers.MapMixin = Ember.Mixin.create
  latitude: DS.attr('number')
  longitude: DS.attr('number')
  query: null

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
        if response.length > 0
          @set('latitude', response[0].lat)
          @set('longitude', response[0].lon)

Doers.Map = Doers.Card.extend(Doers.MapMixin)
