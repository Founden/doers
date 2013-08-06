Doers.PhotoView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'textView', 'photoView', 'footerView']
    titleView: Doers.CardTitleView
    textView: Doers.CardTextView
    photoView: Doers.CardPhotoView.extend
      contentBinding: 'parentView.content'
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView.extend
    uploadView: Ember.ContainerView.extend
      assetAttribute: 'image'
      contentBinding: 'parentView.content'
      classNames: ['asset-upload']
      childViews: ['hiddenFileInputView', 'dropAreaView']

      doNothing: (event) ->
        event.preventDefault()
        false

      onDropOrChange: (event) ->
        input = event.dataTransfer || event.target
        if input.files and input.files[0]
          @get('parentView').handleUpload(event, input.files[0])
        @doNothing(event)

      handleUpload: (event, attachment) ->
        if !attachment.type.match('image')
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
        if @get('content.id')
          @get('controller').updatePhoto(@get('content'))
      ).observes('content.attachment', 'content.id')

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
        templateName: 'shared/asset_uploader'
        isDragging: false
        isVisible: true
        isError: false
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

  settingsView: Doers.CardSettingsView
