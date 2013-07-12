Doers.RESTSerializer = DS.RESTSerializer.extend
  # Overwrite this in order to get the STI card models extended properly
  materialize: (record, serialized, prematerialized) ->
    if type = serialized.type
      mixin = Doers.get(type + 'Mixin')
      klass = Doers.get(type)
      record.constructor = klass
      record.reopen(mixin)
    @_super(record, serialized, prematerialized)

  # Map STI root type to parent model
  rootForType: (type) ->
    if type.__super__.constructor == DS.Model
      @_super(type)
    else
      @_super(type.__super__.constructor)
