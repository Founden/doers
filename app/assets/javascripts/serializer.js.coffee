Doers.RESTSerializer = DS.RESTSerializer.extend
  # Overwrite this in order to get the STI card models extended properly
  materialize: (record, serialized, prematerialized) ->
    if type = serialized.type
      klass = Doers.get(type)
      record.constructor = record.constructor.extend(klass)
      record.reopen(klass)
    @_super(record, serialized, prematerialized)
