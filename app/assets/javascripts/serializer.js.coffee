Doers.ApplicationSerializer = DS.ActiveModelSerializer.extend

  # Apparently ember data is ignoring readOnly flag
  serializePolymorphicType: (record, json, relationship) ->
    unless relationship.options.readOnly
      @_super(record, json, relationship)

  extractArray: (store, type, payload) ->
    type.typeKey = type.superclass.typeKey || type.typeKey
    @_super(store, type, payload)
