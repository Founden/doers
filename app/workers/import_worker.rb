require 'net/http'
require 'uri'

# Angel List import worker
class ImportWorker
  attr_accessor :access_token, :startup_id, :user, :project
  include SuckerPunch::Worker

  # Worker tasks go here
  def perform(user_id, startup_id)
    self.startup_id = startup_id
    ActiveRecord::Base.connection_pool.with_connection do
      self.user = ::User.find(user_id)
      self.access_token = user.identities.first.token
      self.run
      self.user.update_attributes(:importing => false)
    end
  end

  # Runs the import
  def run
    if import_project
      import_project_comments
      ::UserMailer.startup_imported(project).deliver
    end
  end

  # Generates startup url
  def startup_url
    'https://api.angel.co/1/startups/%s?access_token=%s' % [
      startup_id, access_token]
  end

  # Generates startup comments url
  def startup_comments_url
    'https://api.angel.co/1/startups/%s/comments?access_token=%s' % [
      startup_id, access_token]
  end

  # Makes calls to the API and processes the returned JSON
  def process_json(url)
    uri = URI.parse(url)
    data = {}
    begin
      response = Net::HTTP.get_response(uri)
      if response.code == '200'
        data = MultiJson.load(response.body)
      end
    rescue
    end
    data
  end

  # Builds a [Project] based on API response
  # @return [Project]
  def import_project
    data = process_json(startup_url)

    if project.nil?
      self.project = user.projects.create!(
        :title => data['name'],
        :description => data['high_concept'],
        :website => data['company_url'],
        :angel_list_id => data['id']
      )
      project.create_logo!(
        :user => user, :attachment => URI.parse(data['thumb_url']))
    end

    project
  end

  # Builds a set of [Comment] based on API response
  def import_project_comments
    data = process_json(startup_comments_url)

    data.each do |comment|
      project.comments.create!({
        :angel_list_id => comment['id'],
        :angel_list_author_id => comment['user']['id'],
        :angel_list_author_name => comment['user']['name'],
        :content => comment['comment'],
        :created_at => comment['created_at']
      })
    end
  end
end
