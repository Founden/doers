Doers.BoardsBuildView = Ember.View.extend

  titleView: Ember.TextField.extend
    focusOut: (event) ->
      @get('controller').update()

  descriptionView: Ember.TextArea.extend
    focusOut: (event) ->
      @get('controller').update()

  deleteButtonView: Doers.DeleteButtonView

  cardsView: Ember.CollectionView.extend
    classNames: ['cards']
    createChildView: (view, attrs) ->
      type = attrs.content.get('type')
      view = @container.resolve('view:card')
      view.reopen(Doers.MovableMixin)
      attrs.content.set('isBuilding', true)
      attrs.templateName = 'cards/%@'.fmt(type.underscore())
      @_super(view, attrs)
