Doers.ApplicationSerializer = DS.ActiveModelSerializer.extend
  serializeIntoHash: (hash, type, record, options) ->
    if @container.resolve('model:card').detect(type)
      type.typeKey = 'card'
    hash[type.typeKey] = @serialize(record, options)
