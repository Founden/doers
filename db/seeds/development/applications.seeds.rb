after 'development:users' do
  email = '%s@coursewa.re' % (ENV['USER'] || 'dev')
  me = User.where(:email => email).first

  # Pre-define `uid` to make it easier for testing
  app = Fabricate(:doorkeeper_app, :owner => me)
  app.update_attribute(:uid, '1234567890987654321')
end

