Doers.ApplicationSerializer = DS.ActiveModelSerializer.extend
  # This ensures the json root key will match initial STI type
  # TODO: make this smarter
  serializeIntoHash: (hash, type, record, options) ->
    if @container.resolve('model:card').detect(type)
      type.typeKey = 'card'
    hash[type.typeKey] = @serialize(record, options)
