Doers.MovableMixin = Ember.Mixin.create
  classNames: ['drag-handler']
  classNameBindings: ['isDragged:moving', 'isDroppable:drop-handler']
  attributeBindings: ['draggable']
  draggable: 'true'
  isDroppable: false
  isDraggedBinding: 'content.moveSource'
  isDroppedBinding: 'content.moveTarget'

  doNothing: (event) ->
    event.preventDefault()
    false

  becameDraggable: ->
    if !@get('isDragged') and !@get('isDroppable')
      @set('isDragged', true)

  becameDroppable: ->
    if !@get('isDragged') and !@get('isDroppable')
      @set('isDroppable', true)

  dragStart: (event) ->
    if event.dataTransfer and event.dataTransfer.setData
      event.dataTransfer.setData('text/plain', @get('id'));
    @becameDraggable()

  dragEnd: (event) ->
    @set('isDragged', false)

  drop: (event) ->
    @set('isDropped', true)
    @set('isDroppable', false)
    @doNothing(event)

  dragOver: (event) ->
    @becameDroppable()
    @doNothing(event)

  dragEnter: (event) ->
    @becameDroppable()
    @doNothing(event)

  dragLeave: (event) ->
    @set('isDroppable', false)
    @doNothing(event)
