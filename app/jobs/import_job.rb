require 'net/http'
require 'uri'

# Angel List import job
class ImportJob < Struct.new(:user, :startup_id)
  attr_accessor :access_token, :project

  # Job starts here
  def perform
    @access_token = user.identities.first.token

    if existing_project = Project.find_by(:external_id => startup_id.to_s)
      ::UserMailer.startup_exists(existing_project, user).deliver
    end

    if !existing_project and import_project
      import_project_comments
      import_project_users
      ::UserMailer.startup_imported(project).deliver
    else
      ::UserMailer.startup_import_failed(user).deliver
    end

    user.update_attributes(:importing => false)
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

  # Generates startup roles url
  def startup_roles_url
    'https://api.angel.co/1/startups/%s/roles?access_token=%s' % [
      startup_id, access_token]
  end

  # Project external type
  # For now just get the first available
  def external_type
    Doers::Config.external_types.first
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
      @project = user.created_projects.create!(
        :title => data['name'],
        :description => data['high_concept'],
        :website => data['company_url'],
        :external_id => data['id'],
        :external_type => external_type
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
        :external_id => comment['id'],
        :external_type => external_type,
        :external_author_id => comment['user']['id'],
        :external_author_name => comment['user']['name'],
        :content => comment['comment'],
        :created_at => comment['created_at']
      })
    end
  end

  # Identifies project users from API response
  def import_project_users
    data = process_json(startup_roles_url)

    data['startup_roles'].each do |role|
      external_id = role['tagged']['id']
      member = User.find_by(:external_id => external_id.to_s)
      project.memberships.create({
        :creator => project.user,
        :user => member
      }) if member && member != project.user
    end
  end
end
