if !ENV['TDDIUM'] && ENV['RAILS_ENV'] != 'production'
  require 'parallel_tests/tasks'
end
