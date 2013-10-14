Doers.Link = Doers.Card.extend
  url: DS.attr('string')
  embed: null

  didLoad: ->
    @search()

  urlChanged: ( ->
    Ember.run.debounce(@, 'search', 200)
  ).observes('url')

  search: ->
    url = @get('url')
    if url and url.match('https?://(.*[^/])') and url.length > 11
      @store.find( 'embed', {url: url}).then (result) =>
        if result and embed = result.get('firstObject')
          @set('embed', embed)
          @set('content', embed.get('title'))
        else
          @set('content', null)

  htmlContent: ( ->
    if html = @get('embed.html')
      html.htmlSafe()
  ).property('embed.html')
