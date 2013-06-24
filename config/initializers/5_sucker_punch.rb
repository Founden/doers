SuckerPunch.config do
  queue :name => :email, :worker => EmailWorker, :workers => 2
  queue :name => :import, :worker => ImportWorker, :workers => 2
end
