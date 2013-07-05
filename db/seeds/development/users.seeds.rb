user = User.find_by(:email => ENV['EMAIL'])
user.update_attribute(:confirmed, true )

# Dummy users
5.times { Fabricate(:user) }
