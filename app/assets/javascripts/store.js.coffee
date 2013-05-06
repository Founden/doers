Doers.Store = DS.Store.extend
  revision: 11
  adapter: Doers.RESTAdapter.create
    bulkCommit: false
    # API End-point namespace
    namespace: 'api/v1'
