Doers.Router.reopen
  rootURL: '/'

Doers.Router.map (match)->
  @route 'dashboard'
  @resource 'projects', ->
    @route('new')
    @resource 'project', {path: ':project_id'}
