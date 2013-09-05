user = User.find_by(:email => ENV['EMAIL'])
user.update_attribute(:confirmed, true )
[1, 2, 4].sample.times do
  Fabricate(:invitation, :user => user)
end

# Dummy users
5.times { Fabricate(:user) }
