Doers.ContentCoverComponent = Ember.Component.extend
  source: null
  image: null
  classNames: ['content-cover']

  imageView: Ember.View.extend
    tagName: 'img'
    attributeBindings: ['src']
    srcBinding: 'parentView.source'

    didInsertElement: ->
      @$().on 'load', (event) =>
        @set('parentView.image', @get('element'))

  canvasView: Ember.View.extend
    tagName: 'canvas'
    sourceBinding: 'parentView.source'
    imageBinding: 'parentView.image'

    blur: ( ->
      if image = @get('image')
        canvas = @get('element')
        canvas.width = image.width
        canvas.height = image.height
        context = canvas.getContext('2d')
        context.globalAlpha = 0.2
        context.drawImage(image, 0, 0)
        for t in [-10...10] by 2
          for n in [-10...10] by 2
            context.drawImage(canvas, -(n - 1), -(t - 1))
        context.globalAlpha = 1
    ).observes('image', 'source')
