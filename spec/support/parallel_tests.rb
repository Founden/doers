unless ENV['TDDIUM']
  require 'parallel_tests'

  if test_env_id = ENV['TEST_ENV_NUMBER']
    Capybara.server_port =
      Capybara::Server.new(nil).send(:find_available_port) + test_env_id.to_i

    RSpec.configure do |config|
      config.before(:each) do
        SimpleCov.command_name 'RSpec:%s_%s' % [ Process.pid, test_env_id ]
      end
    end if defined?(SimpleCov)
  end
end
