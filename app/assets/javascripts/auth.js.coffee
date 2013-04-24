Auth.Config.reopen
  tokenCreateUrl: '/oauth/authenticate'
  tokenKey: 'access_token'
  urlAuthentication: true

  # Redirect options
  # authRedirect: true
  smartSignInRedirect: true
  signInRoute: 'sign_in'

  # RememberMe options
  rememberMe: true
  rememberStorage: 'localStorage'
  rememberTokenKey: 'access_token'
