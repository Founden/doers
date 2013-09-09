Doers.BoardsBuildView = Ember.View.extend
  buildCardsView: Ember.CollectionView.extend
    classNames: ['cards', 'build']

    createChildView: (view, attrs) ->
      attrs.content.set('isBuilding', true)
      type = attrs.content.get('type')
      view = @container.resolve('view:card-edit')
      view.reopen(Doers.MovableMixin)
      attrs.templateName = 'cards/build/%@'.fmt(type.underscore())
      @_super(view, attrs)
