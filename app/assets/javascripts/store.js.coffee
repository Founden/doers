Doers.Store = DS.Store.extend
  adapter: Doers.RESTAdapter.create
    bulkCommit: false
    # API End-point namespace
    namespace: 'api/v1'
  # We need this hook in order to get the STI card models loaded properly
  load: (type, data, parameterized) ->
    if data.type
      type = Doers[data.type]
    @_super(type, data, parameterized)
