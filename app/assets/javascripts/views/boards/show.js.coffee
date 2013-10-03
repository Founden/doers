Doers.BoardsShowView = Ember.View.extend

  titleView: Ember.TextField.extend
    focusOut: (event) ->
      @get('controller').update()

  descriptionView: Ember.TextArea.extend
    focusOut: (event) ->
      @get('controller').update()

  deleteButtonView: Doers.DeleteButtonView
