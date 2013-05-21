EasyAuth.config do |c|
  c.oauth2_client(
    :angel_list,
    Doers::Config.oauth2_providers.angel_list.client_id,
    Doers::Config.oauth2_providers.angel_list.secret_key
  )
end
