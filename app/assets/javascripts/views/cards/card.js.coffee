Doers.CardView = Ember.View.extend
  classNames: ['card-item']
  classNameBindings: ['content.slug']

  editView: ( ->
    @get('controller.container').resolve('view:card-edit')
  ).property('controller')

  editTemplateName: ( ->
    type = @get('content.type') || ''
    'cards/edit/%@'.fmt(type.underscore())
  ).property('content.type')

  click: (event) ->
    @set('controller.selectedCardView', @)
    @set('content.isEditing', true)
