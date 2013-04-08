# Cleanup unused rake tasks
Rake::TaskManager.class_eval do
  def remove_task(task_name)
    @tasks.delete(task_name.to_s)
  end
end

%w(
  db:seed db:fixtures:load about doc:app time:zones:all spec:rcov rails:template
).each do |task|
  Rake.application.remove_task task
end

