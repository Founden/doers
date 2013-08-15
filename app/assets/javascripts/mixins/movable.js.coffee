Doers.MovableMixin = Ember.Mixin.create
  classNames: ['drag-handler']
  classNameBindings: ['isDragged:moving', 'isDroppable:drop-handler']
  attributeBindings: ['draggable']
  draggable: 'true'
  isDragged: false
  isDroppable: false

  doNothing: (event) ->
    event.preventDefault()
    false

  dragStart: (event) ->
    @set('isDragged', true)

  dragEnd: (event) ->
    @set('isDragged', false)

  drop: (event) ->
    @set('isDroppable', false)
    @doNothing(event)

  dragEnter: (event) ->
    @set('isDroppable', true) unless @get('isDragged')
    @doNothing(event)

  dragLeave: (event) ->
    @set('isDroppable', false)
    @doNothing(event)

  handleReordering: (from, to) ->
    false
