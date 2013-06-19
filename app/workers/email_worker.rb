# Emails worker
class EmailWorker
  include SuckerPunch::Worker

  # Worker tasks go here
  def perform(method, user_id)
    ActiveRecord::Base.connection_pool.with_connection do
      user = User.find(user_id)
      UserMailer.send(method.to_sym, user).deliver
    end
  end
end
