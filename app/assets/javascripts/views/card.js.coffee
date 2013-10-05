Doers.CardView = Ember.View.extend
  classNames: ['card']
  classNameBindings: ['content.slug', 'typeClassName']

  controller: ( ->
    if type = @get('content.type')
      @container.resolve('controller:' + type + 'Card').create
        content: @get('content')
  ).property('content.type')

  templateName: ( ->
    if type = @get('content.type')
      'cards/%@'.fmt(type.underscore())
  ).property('content.type')

  typeClassName: ( ->
    if type = @get('content.type')
      'type-%@'.fmt(type.dasherize())
  ).property('content.type')

  uploadView: Doers.UploaderView
