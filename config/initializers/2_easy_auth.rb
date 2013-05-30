EasyAuth.config do |c|
  c.oauth2_client(
    :angel_list,
    Doers::Config.oauth2_providers.angel_list.client_id,
    Doers::Config.oauth2_providers.angel_list.secret_key
  )
end


module EasyAuth::Models::Identities::Oauth2::AngelList
  def account_attributes_map
    { :email => 'email', :name => 'name', :angel_list_id => 'id' }
  end
end
