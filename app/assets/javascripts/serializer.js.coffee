Doers.ApplicationSerializer = DS.ActiveModelSerializer.extend

  # Apparently ember data is ignoring readOnly flag
  serializePolymorphicType: (record, json, relationship) ->
    unless relationship.options.readOnly
      @_super(record, json, relationship)
