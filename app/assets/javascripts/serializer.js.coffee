# Doers.RESTSerializer = DS.RESTSerializer.extend
#   # Overwrite this in order to get the STI card models extended properly
#   materialize: (record, serialized, prematerialized) ->
#     if type = serialized.type
#       mixin = Doers.get(type + 'Mixin')
#       klass = Doers.get(type)
#       record.constructor = klass
#       record.reopen(mixin)
#     @_super(record, serialized, prematerialized)

#   # Map STI root type to parent model
#   rootForType: (type) ->
#     if type.__super__.constructor == DS.Model
#       @_super(type)
#     else
#       @_super(type.__super__.constructor)

Doers.ApplicationSerializer = DS.ActiveModelSerializer.extend
  typeForRoot: (root) ->
    # console.log 'typeForRoot', root
    camelized = Ember.String.camelize(root)
    Ember.String.singularize(camelized)

  serializeIntoHash: (hash, type, record, options) ->
    if @container.resolve('model:card').detect(type)
      type.typeKey = 'card'
    hash[type.typeKey] = this.serialize(record, options)

  extractArray: (store, primaryType, payload) ->
    console.log primaryType, payload
    @_super(store, primaryType, payload)
