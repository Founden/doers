Doers.VideoEmbedView = Ember.View.extend
  tagName: 'iframe'
  attributeBindings: ['src']
  showinfo: 0
  controls: 0

  params: ( ->
    $.param
      showinfo: @get('showinfo')
      controls: @get('controls')
  ).property('content.videoId')

  src: ( ->
    'http://www.youtube.com/embed/%@?%@'.fmt(@get('content.videoId'), @get('params'))
  ).property('params')
