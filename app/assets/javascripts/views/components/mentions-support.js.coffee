Doers.MentionsSupportComponent = Ember.Component.extend
  isVisible: false
  keyCodes:
    '@':
      code: 50
      shift: true
    arrowDown:
      code: 40
      shift: false
    arrowUp:
      code: 38
      shift: false

  keyPressEvent: null

  search: ''
  results: null
  selectedIndex: 0

  textarea: null

  caret: Ember.Object.create
    top: 0
    left: 0

  searchChanged: ( ->
    search = @get('search')
    results = @get('results')
    content = []
    if search and results.get('length') > 0
      @set('selectedIndex', 0)
      searchRegexp = new RegExp(search, 'i')
      content = results.filter (member) ->
        searchRegexp.test member.get('nicename').toLowerCase()
    else
      @set('selectedIndex', -1)

    @set('content', content)
  ).observes('search', 'results')

  keyPressEventChanged: ( ->
    event = @get('keyPressEvent')
    amp = @get('keyCodes.@')
    if event and amp.code == event.which and amp.shift == event.shiftKey
      @set('textarea', event.target)
      @updateCaretOffset()

      @set('isVisible', true)
  ).observes('keyPressEvent')

  caretChanged: ( ->
    @$().css
      position: 'relative'
      top: @get('caret.top')
      left: @get('caret.left')
  ).observes('caret.top', 'caret.left')

  updateCaretOffset: ->
    textarea = @get('textarea')
    # This is the mirror of the textarea
    mirror = $('<div></div>')
    # And this is the caret of the mirrored textarea
    cursor = $('<em></em>').text(' ')
    # Set the content of the textarea
    mirror.text(@textBeforeCaret())
    # Set the same class names
    mirror.get(0).classList = textarea.classList
    # Hide mirror
    mirror.css
      position: 'absolute',
      top: 0,
      left: -9999,
      overflow: 'auto',
      'white-space': 'pre-line'

    cursor.appendTo(mirror)
    @$().before(mirror)

    # Now just capture its position
    position = cursor.position()
    cursor.remove()
    mirror.remove()

    @set('caret.top', position.top + cursor.height() - textarea.scrollTop)
    @set('caret.left', position.left)

  textBeforeCaret: ->
    textarea = @get('textarea')
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

  searchInputEnter: (event) ->
    content = @get('parentView.content')
    index = @get('parentView.selectedIndex')
    if item = content.objectAt(index)
      @get('parentView').appendMention(item.get('nicename'))
      @set('parentView.isVisible', false)
    false

  searchInputKeyPress: (event) ->
    arrDown = @get('parentView.keyCodes.arrowDown')
    arrUp = @get('parentView.keyCodes.arrowUp')
    index = @get('parentView.selectedIndex')
    contentLength = @get('parentView.content.length') - 1
    keyMatched = false

    if arrDown.code == event.which
      if index < contentLength
        index += 1
        keyMatched = true

    if arrUp.code == event.which
      if index > 0
        index -= 1
        keyMatched = true

    if keyMatched
      @set('parentView.selectedIndex', index)
      event.preventDefault()

    return !keyMatched

  selectedIndexChanged: ( ->
    index = @get('selectedIndex')
    content = @get('content')

    return if index < 0

    item = content.objectAt(index)
    if item
      content.setEach('isSelected', false)
      item.set('isSelected', true)
  ).observes('selectedIndex', 'content')

  appendMention: (mention) ->
    textarea = @get('textarea')
    oldValue = textarea.value
    newValue = @textBeforeCaret()
    newValue += mention

    # Snapshot the new position inside textarea
    newCaretPosition = newValue.length

    newValue += oldValue.substring(@textBeforeCaret().length, oldValue.length)
    textarea.value = newValue
    textarea.selectionStart = textarea.selectionEnd = newCaretPosition

  actions:
    mentionSelected: (found) ->
      @appendMention(found.get('nicename'))
      @set('isVisible', false)
