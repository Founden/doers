Doers.CardView = Ember.View.extend
  classNames: ['card']
  classNameBindings: ['content.slug', 'typeClassName']

  templateName: ( ->
    type = @get('content.type') || ''
    'cards/%@'.fmt(type.underscore())
  ).property('content.type')

  typeClassName: ( ->
    type = @get('content.type') || ''
    'type-%@'.fmt(type.dasherize())
  ).property('content.type')

  controller: ( ->
    type = @get('content.type') || ''
    @container.resolve('controller:' + type)
  ).property('content.type')
