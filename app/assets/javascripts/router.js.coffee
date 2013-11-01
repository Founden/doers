Doers.Router.map (match)->
  @resource 'projects', ->
    @route('new')
    @route('add-board', {path: ':project_id/add-board'})
    @route('show', {path: ':project_id'})
    @route('import')
    @route('import-running')
  @resource 'boards', ->
    @route 'show', {path: ':board_id'}
  @resource 'topic', {path: 'topic/:topic_id'}
