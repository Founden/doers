Doers.BoardsShowView = Ember.View.extend

  selectedCard: null

  cardItemView: Ember.View.extend Doers.MovableMixin,
    classNames: ['card-item']
    classNameBindings: ['classType']

    classType: ( ->
      if type = @get('content.type')
        'card-item-%@'.fmt(@get('content.type').dasherize())
    ).property('content.type')

    templateName: ( ->
      if type = @get('content.type')
        'cards/%@'.fmt(@get('content.type').underscore())
    ).property('content.type')

    templateNameDidChange: ( ->
      @rerender()
    ).observes('templateName')

    click: (event) ->
      @set('parentView.selectedCard', @get('content'))
      @set('content.isEditing', true)

  cardEditView: Ember.View.extend
    classNames: ['card']
    contentBinding: 'parentView.selectedCard'
    isVisibleBinding: 'content.isEditing'

    templateName: ( ->
      if type = @get('content.type')
        'cards/edit/%@'.fmt(@get('content.type').underscore())
    ).property('content.type')

    templateNameDidChange: ( ->
      @rerender()
    ).observes('templateName')

    saveButtonView: Ember.View.extend
      contentBinding: 'parentView.content'
      clickBinding: 'controller.save'

    uploadView: Doers.UploaderView
