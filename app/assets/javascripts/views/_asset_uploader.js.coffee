Doers.AssetUploaderView = Ember.View.extend
  assetAttribute: null
  attachment: null
  attachmentDescription: null
  templateName: 'shared/asset_uploader'
  isDragging: false
  isVisible: true
  isError: false
  classNames: ['asset-upload']
  classNameBindings: ['isDragging:hover']

  doNothing: (event) ->
    event.preventDefault()
    false

  dragOver: (event) ->
    @set('isDragging', true)
    @doNothing(event)

  dragEnter: (event) ->
    @set('isDragging', true)
    @doNothing(event)

  dragLeave: (event) ->
    @set('isDragging', false)
    @doNothing(event)

  drop: (event) ->
    input = event.dataTransfer || event.target
    if input.files and input.files[0]
      @handleUpload(event, input.files[0])
    @doNothing(event)

  handleUpload: (event, attachment) ->
    self = @
    if !attachment.type.match('image')
      @set('isError', true)
    else
      @set('isError', false)
      reader = new FileReader()
      reader.onload = (e) ->
        result = (e.target || e.srcResult).result
        self.set('attachmentDescription', attachment.name)
        self.set('attachment', result)
      reader.readAsDataURL(attachment)

  createAttachment: ->
    self = @
    attachmentDescription = @get('attachmentDescription')
    attachment = @get('attachment')
    assetAttribute = @get('assetAttribute')

    # TODO: update to below once Ember.js#2957 gets released
    # klass = @get('container').resolve('model:asset')
    klass = Doers.Asset
    asset = klass.create
      description: attachmentDescription || self.get('content.title')
      attachment: attachment
      project: self.get('content.project')
      board: self.get('content.board')
      assetableType: self.get('content.assetableType')
      assetableId: self.get('content.id')
    asset.save().then ->
      self.get('content').set(assetAttribute, asset)

  updateAttachment: ->
    attachmentDescription = @get('attachmentDescription')
    attachment = @get('attachment')
    assetAttribute = @get('assetAttribute')
    if asset = @get('content').get(assetAttribute)
      asset.set('description', attachmentDescription)
      asset.set('attachment', attachment)
      asset.save()
    else
      false

  attachmentObserver: ( ->
    window.card = @get('content')
    if @get('attachment') and @get('content.id')
      @updateAttachment() || @createAttachment()
  ).observes('attachment', 'content.id')
