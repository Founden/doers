Doers.ProjectsShowView = Ember.View.extend

  boardItemView: Ember.View.extend
    classNames: ['board-item']
    classNameBindings: ['isStacked:stacked', 'content.isNew:new']

    isStacked: ( ->
      @get('controller.isEditing') && !@get('content.isNew')
    ).property('controller.isEditing')
