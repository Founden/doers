Doers.TopicCardComponent = Ember.Component.extend

  classNames: ['card']

  controller: ( ->
    if type = @get('card.type')
      @container.resolve('controller:' + type + 'Card').create
        content: @get('card')
        container: @container
        store: @store
  ).property('card.type')

  templateName: ( ->
    if type = @get('card.type')
      'components/card-%@'.fmt(type.underscore())
  ).property('card.type')
