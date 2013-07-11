Doers.RESTSerializer = DS.RESTSerializer.extend
  # Overwrite this in order to get the STI card models extended properly
  materialize: (record, serialized, prematerialized) ->
    if type = serialized.type
      record.constructor = record.constructor.extend(Doers.get(type))
      record.reopen(Doers.get(type))
    @_super(record, serialized, prematerialized)
