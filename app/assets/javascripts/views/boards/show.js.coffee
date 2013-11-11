Doers.BoardsShowView = Ember.View.extend

  titleView: Ember.TextField.extend
    focusOut: (event) ->
      @get('controller').update()

  descriptionView: Ember.TextArea.extend
    focusOut: (event) ->
      @get('controller').update()

  deleteButtonView: Doers.DeleteButtonView

  topicItemView: Ember.View.extend Doers.MovableMixin,
    templateName: 'partials/topic_item'
    classNames: ['topic']
    classNameBindings: ['content.slug', 'content.isNew:new-topic']
