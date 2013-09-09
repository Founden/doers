Doers.BoardsShowView = Ember.View.extend

  titleView: Ember.TextField.extend
    focusOut: (event) ->
      @get('controller').update()

  descriptionView: Ember.TextArea.extend
    focusOut: (event) ->
      @get('controller').update()

  cardsView: Ember.CollectionView.extend
    classNames: ['cards']
    createChildView: (view, attrs) ->
      type = attrs.content.get('type')
      view = @container.resolve('view:card')
      attrs.templateName = 'cards/%@'.fmt(type.underscore())
      @_super(view, attrs)
