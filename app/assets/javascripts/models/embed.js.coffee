Doers.Embed = DS.Model.extend
  url: DS.attr('string', readOnly: true)
  title: DS.attr('string', readOnly: true)
  html: DS.attr('string', readOnly: true)
  embedType: DS.attr('string', readOnly: true)
  providerName: DS.attr('string', readOnly: true)
  thumbnailUrl: DS.attr('string', readOnly: true)
  embedUrl: DS.attr('string', readOnly: true)
  authorUrl: DS.attr('string', readOnly: true)
  authorName: DS.attr('string', readOnly: true)
  width: DS.attr('number', readOnly: true)
  height: DS.attr('number', readOnly: true)

  mediaUrl: ( ->
    @get('thumbnailUrl') || @get('embedUrl')
  ).property('embedUrl', 'thumbnailUrl')
