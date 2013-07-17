Doers.BoardView = Ember.View.extend

  cardView: Ember.View.extend
    classNames: ['card']
    classNameBindings: ['typeClassName']

    typeClassName: ( ->
      if type = @get('content.type')
        @get('content.type').dasherize()
    ).property('content.type')
