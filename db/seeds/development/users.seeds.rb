# Main user
email = '%s@geekcelerator' % (ENV['USER'] || 'dev')
user = Fabricate(:user)

# Dummy users
5.times {
  Fabricate(:user)
}
