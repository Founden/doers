Doers.Router.map (match)->
  @resource 'projects', ->
    @route('new')
    @route('show', {path: ':project_id'})
    @route('import')
    @route('import-running')
  @resource 'boards', ->
    @route 'new'
    @route 'show', {path: ':board_id'}
    @route 'build', {path: ':board_id/build'}
  @resource 'memberships', ->
