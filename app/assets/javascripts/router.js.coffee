Doers.Router.reopen
  rootURL: '/'

Doers.Router.map (match)->
  @route 'dashboard'
  @resource 'projects', ->
    @route('new')
    @route('show', {path: ':project_id'})
    @route('import')
    @route('import-running')
    @resource 'boards', {path: ':project_id/boards'}, ->
      @route 'show', {path: ':board_id'}
