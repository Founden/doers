Doers.BoardsShowView = Ember.View.extend
  cardsView: Ember.CollectionView.extend
    classNames: ['cards']
    createChildView: (view, attrs) ->
      type = attrs.content.get('type')
      view = @container.resolve('view:card')
      attrs.templateName = 'cards/%@'.fmt(type.underscore())
      @_super(view, attrs)
