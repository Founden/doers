SuckerPunch.config do
  queue :name => :email, :worker => EmailWorker, :workers => 2
end
