Doers.CardView = Ember.ContainerView.extend Doers.MovableMixin,
  classNames: ['card']
  classNameBindings: [
    'typeClassName', 'isEditing:edit', 'content.style', 'content.slug']
  childViews: ['settingsView', 'contentView', 'editView']
  isEditingBinding: 'content.isEditing'
  isBuildingBinding: 'content.isBuilding'

  typeClassName: ( ->
    if type = @get('content.type')
      @get('content.type').dasherize()
  ).property('content.type')
