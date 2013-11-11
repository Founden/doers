require 'party_foul/processors/delayed_job' if defined?(PartyFoul)

PartyFoul.configure do |config|
  # The collection of exceptions PartyFoul should not be allowed to handle
  # The constants here *must* be represented as strings
  config.blacklisted_exceptions = [
    'ActiveRecord::RecordNotFound', 'ActionController::RoutingError']

  # The OAuth token for the account that is opening the issues on GitHub
  config.oauth_token            = Doers::Config.github.oauth_token

  # The API endpoint for GitHub. Unless you are hosting a private
  # instance of Enterprise GitHub you do not need to include this
  config.api_endpoint           = 'https://api.github.com'

  # The Web URL for GitHub. Unless you are hosting a private
  # instance of Enterprise GitHub you do not need to include this
  config.web_url                = 'https://github.com'

  # The organization or user that owns the target repository
  config.owner                  = Doers::Config.github.owner

  # The repository for this application
  config.repo                   = Doers::Config.github.repository

  # The branch for your deployed code
  # config.branch               = 'master'

  # Additional labels to add to issues created
  # config.additional_labels    = ['production']
  config.additional_labels    = ['pf']
  # or
  # config.additional_labels    = Proc.new do |exception, env|
  #   []
  # end

  # Limit the number of comments per issue
  # config.comment_limit        = 10

  config.processor = PartyFoul::Processors::DelayedJob
end if defined?(PartyFoul)
