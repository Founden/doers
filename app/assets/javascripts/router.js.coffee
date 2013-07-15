Doers.Router.reopen
  rootURL: '/'

Doers.Router.map (match)->
  @route 'dashboard'
  @resource 'projects', ->
    @route('new')
    @route('import')
    @route('import-running')
    @resource 'project', {path: ':project_id'}
    @resource 'boards', {path: ':project_id/boards'}, ->
      @resource 'board', {path: ':board_id'}
