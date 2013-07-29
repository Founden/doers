Doers.AddressAutocompleteView = Ember.View.extend
  classNames: ['autocomplete']

  searchField: Ember.TextField.extend
    search: ( ->
      $.ajax
        url: 'http://nominatim.openstreetmap.org/search'
        dataType: 'json'
        data:
          q: @get('value')
          format: 'json'
        success: (response) =>
          @set('parentView.results', response)
    ).observes('value')

  searchResults: Ember.CollectionView.extend
    tagName: 'ul'
    contentBinding: 'parentView.results'
    mapBinding: 'parentView.content'

    itemViewClass: Ember.View.extend
      mapBinding: 'parentView.map'
      template: Ember.Handlebars.compile('{{view.content.display_name}}')

      click: (event) ->
        @set('map.content', @get('content.display_name'))
        @set('map.latitude', @get('content.lat'))
        @set('map.longitude', @get('content.lon'))
