Doers.DeleteConfirmationMixin = Ember.Mixin.create
  confirm: (record) ->
    record.set('deleteConfirmation', true)

  cancel: (record) ->
    record.set('deleteConfirmation', false)

  remove: (record) ->
    notNew = !!record.get('id')
    record.deleteRecord()
    record.save() if notNew
    @get('content').removeObject(record) if @get('content').removeObject
