shared_examples 'an email from us' do
  its(:subject) { should include(Doers::Config.app_name) }
  its(:from) { should include(
    Mail::Address.new(Doers::Config.default_email).address) }
  its(:return_path) { should include(
    Mail::Address.new(Doers::Config.contact_email).address) }
end
