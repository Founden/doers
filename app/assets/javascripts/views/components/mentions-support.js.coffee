Doers.MentionsSupportComponent = Ember.Component.extend
  isVisible: false
  mentionTrigger: '@'
  keyPressEvent: null

  search: ''
  mention: false
  results: null

  tabEvent: $.Event('keydown', keyCode: 9)

  content: ( ->
    search = @get('search')
    results = @get('results')
    if search and results.get('length') > 0
      searchRegexp = new RegExp(search, 'i')
      results.filter (member) ->
        searchRegexp.test member.get('nicename').toLowerCase()
    else
      []
  ).property('search', 'results')

  keyPressEventChanged: ( ->
    event = @get('keyPressEvent')
    if event and @get('mentionTrigger') == String.fromCharCode(event.which)
      @set('isVisible', true)
  ).observes('keyPressEvent')

  becameVisible: ->
    # Trigger tab to switch to focus here
    $('[tabindex="2"]').focus()

  becameHidden: ->
    @set('search', null)
    # Trigger tab to switch to parent input
    $('[tabindex="1"]').focus()

  searchInputCancel: (event) ->
    @set('parentView.isVisible', false)

  actions:
    mentionSelected: (found) ->
      @set('mention', found.get('nicename'))
      @set('isVisible', false)
