Doers.MentionsSupportComponent = Ember.Component.extend
  isVisible: false
  mentionTrigger: '@'
  keyPressEvent: null

  search: ''
  mention: false
  results: null

  caret: Ember.Object.create
    top: 0
    left: 0

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
      @updateCaretOffset(event.target)

      @set('isVisible', true)
  ).observes('keyPressEvent')

  caretChanged: ( ->
    @$().css
      position: 'relative'
      top: @get('caret.top')
      left: @get('caret.left')
  ).observes('caret.top', 'caret.left')

  updateCaretOffset: (textarea) ->
    # This is the mirror of the textarea
    mirror = $('<div></div>')
    # And this is the caret of the mirrored textarea
    cursor = $('<span></span>').text(' ')
    # Set the content of the textarea
    mirror.text(textarea.value)
    # Set the same class names
    mirror.get(0).classList = textarea.classList
    # Hide mirror
    mirror.css
      position: 'absolute',
      top: 0,
      left: -9999,
      overflow: 'auto',
      'white-space': 'pre-wrap'

    cursor.appendTo(mirror)
    @$().before(mirror)

    # Now just capture its position
    position = cursor.position()
    cursor.remove()
    mirror.remove()

    @set('caret.top', position.top + cursor.height() - textarea.scrollTop)
    @set('caret.left', position.left)

  textBeforeCaret: (textarea) ->
    # Sane browsers
    if textarea.selectionEnd
      return textarea.value.substring(0, textarea.selectionEnd)
    # IE
    else if document.selection
      range = textarea.createTextRange()
      range.moveStart('character', 0)
      range.moveEnd('textedit')
      return range.text
    # lynx
    else
      textarea.value

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
