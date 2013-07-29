Doers.LinkMixin = Ember.Mixin.create
  result: null
  embed: null

  contentChanged: ( ->
    url = @get('content')
    if url and url.match('https?://(.*[^/])') and url.length > 11
      @set('result', Doers.Embed.find({url: url}))
  ).observes('content')

  resultChaned: ( ->
    result = @get('result')
    if result and embed = result.get('firstObject')
      @set('embed', embed)
      @set('title', embed.get('title'))
    else
      @set('title', null)
  ).observes('result.isLoaded')

  htmlContent: ( ->
    if html = @get('embed.html')
      html.htmlSafe()
  ).property('embed.html')

Doers.Link = Doers.Card.extend(Doers.LinkMixin)
