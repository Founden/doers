desc 'Run cane to check quality metrics'
begin
  require 'cane/rake_task'
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 20
  end
rescue LoadError
  task :quality do
    puts 'Cane is not installed, :quality task unavailable'
  end
end

desc 'Run brakeman for security analysis'
task :brakeman do
  require 'brakeman' rescue puts(
    'Brakeman is not installed, :brakeman task unavailable')
  sh 'brakeman .' if defined?(Brakeman)
end

desc 'Show some QA details about the code'
task qa: [:about, :brakeman, :stats, 'doc:stats', :quality]
