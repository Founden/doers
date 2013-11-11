Doers.AssetUploaderComponent = Ember.Component.extend
  isError: false
  attributeName: 'image'
  assetAttribute: 'image'
  classNames: ['uploader']

  doNothing: (event) ->
    event.preventDefault()
    false

  onDropOrChange: (event) ->
    input = event.dataTransfer || event.target
    if input.files and input.files[0]
      @get('parentView').handleUpload(event, input.files[0])
    @doNothing(event)

  handleUpload: (event, attachment) ->
    if !(/image/).test(attachment.type)
      @set('isError', true)
    else
      @set('isError', false)
      reader = new FileReader()
      reader.onload = (e) =>
        result = (e.target || e.srcResult).result
        @set('content.attachmentDescription', attachment.name)
        @set('content.attachment', result)
      reader.readAsDataURL(attachment)

  attachmentObserver: ( ->
    object = @get('content')
    data =
      attr: @get('attributeName'),
      desc: object.get('attachmentDescription'),
      data: object.get('attachment')
    if object.get('isNew')
      object.save().then =>
        @createOrUpdateAsset(data)
    else
      @createOrUpdateAsset(data)
  ).observes('content.attachment')

  # Creates or updates an asset
  # @param data [Hash], a set of asset options
  #   Includes a key: `attr` the asset attribute name
  #                   `desc` the asset description
  #                   `url` the asset URI to use for `attachment`
  #                   `data` the asset base64 data to use for `attachment`
  createOrUpdateAsset: (data) ->
    object = @get('content')
    if object.get(data.attr)
      @updateAsset(data)
    else
      @createAsset(data)

  createAsset: (data) ->
    object = @get('content')
    asset = @get('content.store').createRecord 'asset',
      attachment: data.url || data.data
      description: data.desc
      project: object.get('project')
      board: object.get('board') || object
      assetableType: object.get('assetableType')
      assetableId: object.get('id')
      type: @get('attributeName').capitalize()
    asset.save().then =>
      object.reload()

  updateAsset: (data) ->
    object = @get('content')
    asset = object.get(data.attr)
    asset.set('attachment', data.url || data.data)
    asset.set('description', data.desc || asset.get('description'))
    asset.save().then ->
      object.reload()

  hiddenFileInputView: Ember.View.extend
    name: 'image'
    attributeBindings: ['type', 'name']
    tagName: 'input'
    type: 'file'
    doNothingBinding: 'parentView.doNothing'
    changeBinding: 'parentView.onDropOrChange'

    didClicked: ( ->
      event = @get('parentView.isAttaching')
      @$().trigger('click', event)
    ).observes('parentView.isAttaching')

  dropAreaView: Ember.View.extend
    isDragging: false
    isVisible: true
    isErrorBinding: 'parentView.isError'
    classNames: ['uploader-drop-area']
    classNameBindings: ['isDragging:hover']
    doNothingBinding: 'parentView.doNothing'
    dropBinding: 'parentView.onDropOrChange'

    click: (event) ->
      @set('parentView.isAttaching', event)
      @doNothing(event)

    dragOver: (event) ->
      @set('isDragging', true)
      @doNothing(event)

    dragEnter: (event) ->
      @set('isDragging', true)
      @doNothing(event)

    dragLeave: (event) ->
      @set('isDragging', false)
      @doNothing(event)
