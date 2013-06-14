Doers.Store = DS.Store.extend
  adapter: Doers.RESTAdapter.create
    bulkCommit: false
    # API End-point namespace
    namespace: 'api/v1'
