Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  progress: DS.attr('number', readOnly: true)
  collections: DS.attr('array', readOnly: true, defaultValue: [])
  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)
  branchesCount: DS.attr('number', readOnly: true)
  cardsCount: DS.attr('number', readOnly: true)

  parentBoard: DS.belongsTo('board', inverse: 'branches')
  project: DS.belongsTo('project', inverse: 'boards')
  user: DS.belongsTo('user', readOnly: true, inverse: 'branchedBoards')
  author: DS.belongsTo('user', readOnly: true, inverse: 'authoredBoards')
  team: DS.belongsTo('team', readOnly: true, inverse: 'boards')
  cover: DS.belongsTo('asset', inverse: 'board')
  activities: DS.hasMany('activity', readOnly: true, inverse: 'board', async: true)
  branches: DS.hasMany('board', inverse: 'parentBoard', async: true)
  memberships: DS.hasMany('membership', readOnly: true, inverse: 'board', async: true)
  topics: DS.hasMany('topic', readOnly: true, inverse: 'board', async: true)
  cards: DS.hasMany('card', readOnly: true, inverse: 'board', async: true)
  parentBoardTopics: DS.hasMany('topic', readOnly: true, inverse: 'board', async: true)

  slug: (->
    'board-' + @get('id')
  ).property('id')

  completedCardsCount: ( ->
    count = 0
    @get('cards').map (card) ->
      if card.get('aligned')
        count++
    count
  ).property('cards.@each.aligned')

  completedCardsProgress: ( ->
    (@get('completedCardsCount') / @get('cardsCount')) * 100
  ).property('completedCardsCount')

  topicsOrderChanged: ->
    topics = @get('topics')
    source = topics.filterProperty('moveSource', true).get('firstObject')
    target = topics.filterProperty('moveTarget', true).get('firstObject')

    if target and source and (target.get('id') != source.get('id'))
      targetAt = target.get('position')
      sourceAt = source.get('position')
      diff = targetAt - sourceAt

      # If we need to shift some topics in between
      if Math.abs(diff) != 1
        # Shift/Unshift any topics which position is affected
        topics.forEach (topic) ->
          topicAt = topic.get('position')
          # If source is before target
          if diff > 0 and topicAt < targetAt and topicAt > sourceAt
            topic.decrementProperty('position')
          # If source is after target (all goes desc order)
          if diff < 0 and topicAt >= targetAt and topicAt < sourceAt
            topic.incrementProperty('position')
          if diff == 0
            topic.set('position', topics.indexOf(topic))

        # Set source after target
        if diff > 0
          source.set('position', targetAt - 1)
        else
          source.set('position', targetAt)

      else
        source.set('position', targetAt)
        target.set('position', sourceAt)

      # Set source after target
      topics.setEach('moveSource', false)
      topics.setEach('moveTarget', false)

      source.save() if source.get('id')
      target.save() if source.get('id')
