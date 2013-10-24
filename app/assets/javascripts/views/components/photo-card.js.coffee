Doers.PhotoCardComponent = Doers.CardComponent.extend

  actions:
    update: ->
      card = @get('content')

      data =
        attr: 'image',
        desc: card.get('attachmentDescription'),
        data: card.get('attachment')

      if card.get('isNew')
        card.save().then =>
          @createOrUpdateAsset(data, card)
      else
        @createOrUpdateAsset(data, card)
