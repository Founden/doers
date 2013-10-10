Doers.Link = Doers.Card.extend
  url: DS.attr('string')
  result: null
  embed: null

  urlChanged: ( ->
    Ember.run.debounce(@, 'search', 200)
  ).observes('url')

  search: ->
    url = @get('url')
    if url and url.match('https?://(.*[^/])') and url.length > 11
      @set('result', Doers.Embed.find({url: url}))

  resultChaned: ( ->
    result = @get('result')
    if result and embed = result.get('firstObject')
      @set('embed', embed)
      @set('content', embed.get('title'))
    else
      @set('content', null)
  ).observes('result.isLoaded')

  htmlContent: ( ->
    if html = @get('embed.html')
      html.htmlSafe()
  ).property('embed.html')
