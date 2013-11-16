Doers.MentionsSupportComponent = Ember.Component.extend
  mentionTrigger: '@'
  mentionsView: null
  keyPressEvent: null
  isVisible: false
  search: ''
  mention: false

  optionsViewClass: Ember.ContainerView.extend
    # TODO: Focus this asap its visible
    # TODO: Add support for key bindings (TAB, ESC... etc).
    searchNameBinding: 'parentView.search'
    childViews: ['userSearchView', 'uploaderView']
    userSearchView: Ember.CollectionView.extend
      mentionBinding: 'parentView.parentView.mention'
      content: ( ->
        if @get('search')
          # TODO: Feed this an AJAX result
          [{id: 1, name: 'Stas'}, {id: 2, name: 'Stefan'}]
        else
          []
      ).property('search')
      emptyView: Ember.TextField.extend
        valueBinding: 'parentView.search'
        placeholder: 'Type a name to search for...'
      itemViewClass: Ember.View.extend
        mentionBinding: 'parentView.mention'
        template: Ember.Handlebars.compile('@{{view.content.name}}')
        click: ->
          @set('mention', @get('content.name'))
    # TODO: Make this a real upload view
    # TODO: Probably hook in map/link cards
    uploaderView: Ember.View.extend
      template: Ember.Handlebars.compile('Click to upload')

  keyPressEventChanged: ( ->
    event = @get('keyPressEvent')
    if event and @get('mentionTrigger') == String.fromCharCode(event.which)
      @set('isVisible', true)
  ).observes('keyPressEvent')
