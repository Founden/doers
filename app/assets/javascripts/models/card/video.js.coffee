Doers.VideoMixin = Ember.Mixin.create
  videoId: DS.attr('string')
  provider: DS.attr('string')
  image: DS.belongsTo('Doers.Asset', readOnly: true)
  query: null
  results: null
  isSearching: false

  queryChanged: ( ->
    @set('isSearching', true)
    $.ajax
      url: 'https://gdata.youtube.com/feeds/api/videos'
      dataType: 'jsonp'
      data:
        q: @get('query')
        alt: 'json'
      success: (response) =>
        @set('results', response.feed.entry)
        @set('isSearching', false)
  ).observes('query')

Doers.Video = Doers.Card.extend(Doers.VideoMixin)
