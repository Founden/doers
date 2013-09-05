Doers.BoardsShowView = Ember.View.extend

  cardsView: Ember.CollectionView.extend
    classNames: ['cards']

    itemViewClass: Ember.View.extend
      classNames: ['card-item']
      classNameBindings: 'classType'
      templateNameBinding: 'templateType'

      classType: ( ->
        if type = @get('content.type')
          'card-item-%@'.fmt(@get('content.type').dasherize())
      ).property('content.type')

      templateType: ( ->
        if type = @get('content.type')
          'cards/%@'.fmt(@get('content.type').underscore())
      ).property('content.type')
